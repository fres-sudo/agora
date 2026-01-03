import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agora/core/cubits/cubits.dart';
import 'package:agora/core/i18n/strings.g.dart';
import 'package:agora/core/services/persistence/persistence_service.dart';
import 'package:agora/core/routes/app_router.dart';
import 'package:agora/di/dependency_injector.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      LocaleSettings.useDeviceLocale();

      PersistenceServiceImpl.instance = await SharedPreferences.getInstance();

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
            theme: ThemeData.light(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
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
