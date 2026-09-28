import 'dart:async';
import 'dart:ui';

import 'package:agora/app/app.dart';
import 'package:agora/app/crash_reporting/sentry_talker_observer.dart';
import 'package:agora/app/device_identity_store_impl.dart';
import 'package:agora/flavors.dart';
import 'package:bloc/bloc.dart';
import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:i18n/i18n.dart';
import 'package:observer/observer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';
import 'package:utils/utils.dart';

void main() async {
  // Resolve the compile-time configuration first — everything downstream
  // (logging, bootstrap mode, backend wiring) keys off it.
  final config = AppConfig.current;

  // Keep flutter_flavorizr's generated `F` in sync with our authoritative
  // AppConfig so the two never diverge (AppConfig is the source of truth).
  F.appFlavor = switch (config.flavor) {
    AppFlavor.dev => Flavor.dev,
    AppFlavor.staging => Flavor.staging,
    AppFlavor.prod => Flavor.prod,
  };

  // Binding must be initialized before Sentry (and before PlatformDispatcher
  // hooks below) so that the Flutter engine is ready for both.
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Sentry before the zone guard so zone errors are also captured.
  // When no DSN is configured (local/dev builds), this block is skipped
  // entirely — zero Sentry overhead.
  if (config.hasSentryDsn) {
    await SentryFlutter.init((options) {
      options.dsn = config.sentryDsn;
      options.environment = config.flavor.name;
      options.debug = config.enableLogging;
      // We deliberately do NOT remove Sentry's FlutterErrorIntegration or
      // OnErrorIntegration here. Setting FlutterError.onError and
      // PlatformDispatcher.instance.onError AFTER SentryFlutter.init
      // (below) overwrites whatever Sentry registered, so our Talker-based
      // path takes over with no double-reporting.
    });
  }

  final talker = Talker(
    settings: TalkerSettings(enabled: config.enableLogging),
    // Observer is only registered when Sentry is active, so dev/local builds
    // have zero Sentry overhead.
    observer: config.hasSentryDsn ? SentryTalkerObserver() : null,
  );

  // Route Flutter framework errors (widget build exceptions, layout errors)
  // through Talker — the SentryTalkerObserver forwards them to Sentry.
  // Setting this AFTER SentryFlutter.init overwrites Sentry's own hook,
  // keeping a single uniform path: error → talker → Sentry.
  FlutterError.onError = (FlutterErrorDetails details) =>
      talker.handle(details.exception, details.stack, '[FlutterError]');

  // Route platform-level async errors through Talker. Must return true to
  // signal the error was handled (suppresses the default crash behaviour).
  // Same overwrite logic as FlutterError.onError above.
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    talker.handle(error, stack, '[PlatformDispatcher]');
    return true;
  };

  await runZonedGuarded(
    () async {
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      LocaleSettings.useDeviceLocale();

      PersistenceServiceImpl.instance = await SharedPreferences.getInstance();

      Bloc.observer = AppBlocObserver(talker: talker);
      talker.info('Booting ${config.appName} — $config');

      // One long-lived database instance owns the app session. We open it here
      // and hand the SAME instance to the provider tree — no second open (see
      // FESTIVAL_POS_TASKS P0-4). The database starts empty; onboarding decides
      // whether to seed a starter catalog on first run.
      final database = AgoraDatabase(driftDatabase(name: K.dbName));

      // Resolved once per install and persisted — every LAN-sync payload
      // this station ever sends is stamped with it (see
      // docs/features/01-lan-sync.md). Cheap enough to do unconditionally
      // even for stations that never pair.
      final deviceId = await DeviceIdentityService(
        store: AppSettingsDeviceIdentityStore(AppSettingsDao(database)),
      ).getOrCreateDeviceId();

      // Tag every Sentry event with stable per-device and per-build context.
      // deviceId is a random UUID generated once per install — not PII.
      if (config.hasSentryDsn) {
        Sentry.configureScope((scope) {
          scope.setTag('flavor', config.flavor.name);
          scope.setTag('bootstrap_mode', config.bootstrapMode.name);
          scope.setTag('tier', config.tierName);
          scope.setUser(SentryUser(id: deviceId.value));
        });
      }

      if (config.bootstrapMode.isHybrid) {
        talker.info(
          '[bootstrap] hybrid mode — api: ${config.apiBaseUrl}, '
          'ws: ${config.wsBaseUrl}',
        );
        // The REST base URL is applied to Dio in AppProviders. The sync engine
        // / websocket is started later once an auth token is available (paid
        // tier seam — FESTIVAL_POS_TASKS P9-2). Nothing to start while offline.
      } else {
        talker.info('[bootstrap] local mode — fully offline, no backend');
      }

      FlutterNativeSplash.remove();
      runApp(
        TranslationProvider(
          child: AgoraApp(
            config: config,
            database: database,
            talker: talker,
            deviceId: deviceId,
          ),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      // All uncaught zone errors route through Talker so they reach
      // SentryTalkerObserver — the same path as every other error.
      talker.handle(error, stackTrace, '[ZonedGuarded] Uncaught error');
    },
  );
}
