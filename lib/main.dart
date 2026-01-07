import 'dart:async';
import 'dart:developer';

import 'package:agora/core/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agora/core/cubits/cubits.dart';
import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';
import 'package:agora/core/routes/app_router.dart';
import 'package:agora/di/dependency_injector.dart';
import 'package:agora/core/database/seeder/data_seeder.dart';
import 'package:agora/core/database/database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:agora/core/misc/constants.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      LocaleSettings.useDeviceLocale();

      PersistenceServiceImpl.instance = await SharedPreferences.getInstance();

      // Seed database if necessary
      final db = AgoraDatabase(driftDatabase(name: K.dbName));
      await DataSeeder(db).seed();
      await db.close();

      FlutterNativeSplash.remove();
      runApp(TranslationProvider(child: AgoraApp()));
    },
    (error, stackTrace) async {
      log('[ZonedGuarded] $error$stackTrace');
    },
  );
}

class AgoraApp extends StatefulWidget {
  const AgoraApp({super.key});

  @override
  State<AgoraApp> createState() => _AgoraAppState();
}

class _AgoraAppState extends State<AgoraApp> {
  AppRouter? _router;

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          _router ??= AppRouter(persistenceService: context.read());
          final themeMode = switch (state) {
            SettedThemeState() => state.mode,
            _ => ThemeMode.system,
          };

          return MaterialApp.router(
            title: "SupaFlutter",
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            routerDelegate: _router?.delegate(),
            routeInformationParser: _router?.defaultRouteParser(),
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
          );
        },
      ),
    );
  }
}
