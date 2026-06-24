import 'package:agora/app/app_providers.dart';
import 'package:agora/app/app_router.dart';
import 'package:i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class AgoraApp extends StatefulWidget {
  const AgoraApp({super.key});

  @override
  State<AgoraApp> createState() => _AgoraAppState();
}

class _AgoraAppState extends State<AgoraApp> {
  AppRouter? _router;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          _router ??= AppRouter(
            persistenceService: context.read<PersistenceService>(),
          );
          final themeMode = switch (state) {
            SettedThemeState() => state.mode,
            _ => ThemeMode.system,
          };

          return MaterialApp.router(
            title: 'Agora',
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
