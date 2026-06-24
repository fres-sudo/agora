import 'package:app_info/app_info.dart';
import 'package:database/database.dart';
import 'package:dio/dio.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:feature_auth/presentation/routes/auth_feature.dart';
import 'package:feature_discounts/presentation/routes/discounts_feature.dart';
import 'package:feature_inventory/presentation/routes/inventory_feature.dart';
import 'package:feature_orders/presentation/routes/orders_feature.dart';
import 'package:feature_products/presentation/routes/products_feature.dart';
import 'package:feature_settings/presentation/routes/settings_feature.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:launcher/launcher.dart';
import 'package:pine/pine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:remote_config/remote_config.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    providers: _providers,
    child: child,
  );
}

final List<SingleChildWidget> _providers = [
  // -------------------------------------------------------------------------
  // Core infrastructure
  // -------------------------------------------------------------------------
  Provider<Talker>(create: (_) => Talker()),
  Provider<LaunchModeMapper>(create: (_) => LaunchModeMapper()),
  Provider<PersistenceService>(create: (_) => PersistenceServiceImpl()),
  Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
  Provider<Dio>(
    create: (ctx) {
      final talker = ctx.read<Talker>();
      final dio = Dio(BaseOptions(contentType: 'application/json'));
      dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printResponseData: true,
          ),
        ),
      );
      return dio;
    },
  ),
  Provider<ConfigService>(create: (_) => ConfigServiceImpl()),
  Provider<VersionCheckerService>(create: (_) => VersionCheckerServiceImpl()),
  Provider<UrlLauncherService>(
    create: (ctx) => UrlLauncherServiceImpl(
      launchModeMapper: ctx.read<LaunchModeMapper>(),
    ),
  ),

  // Database (shared by all features via ProxyProvider)
  Provider<AgoraDatabase>(
    create: (_) => AgoraDatabase(driftDatabase(name: K.dbName)),
    dispose: (_, db) => db.close(),
  ),

  // -------------------------------------------------------------------------
  // App-level repositories + BLoCs
  // -------------------------------------------------------------------------
  RepositoryProvider<ConfigRepository>(
    create: (ctx) => ConfigRepositoryImpl(
      logger: ctx.read<Talker>(),
      service: ctx.read<ConfigService>(),
    ),
  ),
  RepositoryProvider<VersionCheckerRepository>(
    create: (ctx) => VersionCheckerRepositoryImpl(
      versionCheckerService: ctx.read<VersionCheckerService>(),
    ),
  ),
  RepositoryProvider<UrlLauncherRepository>(
    create: (ctx) => UrlLauncherRepositoryImpl(
      urlLauncherService: ctx.read<UrlLauncherService>(),
    ),
  ),

  BlocProvider<ThemeCubit>(
    create: (ctx) =>
        ThemeCubit(persistenceService: ctx.read<PersistenceService>())..load(),
  ),
  BlocProvider<ConfigCubit>(
    create: (ctx) =>
        ConfigCubit(configRepository: ctx.read<ConfigRepository>()),
  ),
  BlocProvider<VersionCheckerBloc>(
    create: (ctx) => VersionCheckerBloc(
      versionCheckerRepository: ctx.read<VersionCheckerRepository>(),
    ),
  ),
  BlocProvider<UrlLauncherBloc>(
    create: (ctx) => UrlLauncherBloc(
      urlLauncherRepository: ctx.read<UrlLauncherRepository>(),
    ),
  ),

  // -------------------------------------------------------------------------
  // Feature providers (each feature registers its own DAOs, repos and BLoCs)
  // -------------------------------------------------------------------------
  ...AuthFeature.providers,
  ...InventoryFeature.providers,   // must be before Products (StocksDao)
  ...ProductsFeature.providers,
  ...OrdersFeature.providers,
  ...DiscountsFeature.providers,
  ...SettingsFeature.providers,
];
