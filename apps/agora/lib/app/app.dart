import 'package:agora/app/app_providers.dart';
import 'package:agora/app/app_router.dart';
import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:agora/app/widgets/app_root_listener.dart';
import 'package:i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

class AgoraApp extends StatefulWidget {
  const AgoraApp({required this.config, required this.database, required this.talker, super.key});

  final AppConfig config;
  final AgoraDatabase database;
  final Talker talker;

  @override
  State<AgoraApp> createState() => _AgoraAppState();
}

class _AgoraAppState extends State<AgoraApp> {
  AppRouter? _router;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      config: widget.config,
      database: widget.database,
      talker: widget.talker,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          _router ??= AppRouter(persistenceService: context.read<PersistenceService>());
          final themeMode = switch (state) {
            SettedThemeState() => state.mode,
            _ => ThemeMode.system,
          };

          return MaterialApp.router(
            title: widget.config.appName,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerDelegate: _router?.delegate(),
            routeInformationParser: _router?.defaultRouteParser(),
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            builder: _flavorBanner,
          );
        },
      ),
    );
  }

  /// Wraps the app in a corner banner for non-production flavors so it is
  /// always obvious which environment a build is pointing at.
  Widget _flavorBanner(BuildContext context, Widget? child) {
    final content = AppRootListener(child: child ?? const SizedBox());
    if (!widget.config.flavor.isNonProduction) return content;
    return Banner(
      message: widget.config.flavor.name.toUpperCase(),
      location: BannerLocation.topStart,
      // Fixed environment-indicator colors (dev = blue, staging = orange) — a
      // debug banner must read the same regardless of the app theme.
      // ignore: avoid_hardcoded_colors
      color: widget.config.flavor.isStaging ? Colors.deepOrange : Colors.blue,
      child: content,
    );
  }
}
