import 'dart:async';
import 'dart:developer';

import 'package:agora/app/app.dart';
import 'package:agora/flavors.dart';
import 'package:bloc/bloc.dart';
import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:i18n/i18n.dart';
import 'package:observer/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      LocaleSettings.useDeviceLocale();

      PersistenceServiceImpl.instance = await SharedPreferences.getInstance();

      final talker = Talker(
        settings: TalkerSettings(enabled: config.enableLogging),
      );
      Bloc.observer = AppBlocObserver(talker: talker);
      talker.info('Booting ${config.appName} — $config');

      // One long-lived database instance owns the app session. We open it here
      // and hand the SAME instance to the provider tree — no second open (see
      // FESTIVAL_POS_TASKS P0-4). The database starts empty; onboarding decides
      // whether to seed a starter catalog on first run.
      final database = AgoraDatabase(driftDatabase(name: K.dbName));

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
          child: AgoraApp(config: config, database: database, talker: talker),
        ),
      );
    },
    (error, stackTrace) async {
      log('[ZonedGuarded] $error$stackTrace');
    },
  );
}
