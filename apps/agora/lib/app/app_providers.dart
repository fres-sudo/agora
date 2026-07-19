import 'package:agora/app/sync_feature.dart';
import 'package:app_info/app_info.dart';
import 'package:app_reset/app_reset.dart';
import 'package:auth_session/auth_session.dart';
import 'package:bloc_exports/bloc_exports.dart' show AppFeature;
import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:dio/dio.dart';
import 'package:feature_auth/presentation/routes/auth_feature.dart';
import 'package:feature_discounts/presentation/routes/discounts_feature.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:feature_inventory/data/sync/stock_sync_handler.dart';
import 'package:feature_inventory/presentation/routes/inventory_feature.dart';
import 'package:feature_kitchen/data/sync/ticket_status_sync_handler.dart';
import 'package:feature_kitchen/presentation/routes/kitchen_feature.dart';
import 'package:feature_onboarding/presentation/routes/onboarding_feature.dart';
import 'package:feature_orders/data/sync/order_sync_handler.dart';
import 'package:feature_orders/presentation/routes/orders_feature.dart';
import 'package:feature_products/presentation/routes/products_feature.dart';
import 'package:feature_reports/presentation/routes/reports_feature.dart';
import 'package:feature_settings/presentation/routes/settings_feature.dart';
import 'package:feature_workforce/presentation/routes/workforce_feature.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:launcher/launcher.dart';
import 'package:pine/pine.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:remote_config/remote_config.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.config,
    required this.database,
    required this.talker,
    required this.deviceId,
    required this.child,
    super.key,
  });

  final AppConfig config;
  final AgoraDatabase database;
  final Talker talker;
  final DeviceId deviceId;
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    providers: _buildProviders(
      config: config,
      database: database,
      talker: talker,
      deviceId: deviceId,
    ),
    child: child,
  );
}

List<SingleChildWidget> _buildProviders({
  required AppConfig config,
  required AgoraDatabase database,
  required Talker talker,
  required DeviceId deviceId,
}) => [
  // ---------------------------------------------------------------------------
  // Configuration (single source of truth for env-driven values)
  // ---------------------------------------------------------------------------
  Provider<AppConfig>.value(value: config),

  // ---------------------------------------------------------------------------
  // Core infrastructure
  // ---------------------------------------------------------------------------
  Provider<Talker>.value(value: talker),
  Provider<LaunchModeMapper>(create: (_) => LaunchModeMapper()),
  Provider<PersistenceService>(create: (_) => const PersistenceServiceImpl()),
  Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
  Provider<Dio>(
    create: (ctx) {
      final dio = Dio(
        BaseOptions(
          contentType: 'application/json',
          baseUrl: config.apiBaseUrl,
        ),
      );
      dio.interceptors.add(
        TalkerDioLogger(
          talker: ctx.read<Talker>(),
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
    create: (ctx) =>
        UrlLauncherServiceImpl(launchModeMapper: ctx.read<LaunchModeMapper>()),
  ),

  // Thermal printer transport (the concrete impl is the only thing that touches
  // the third-party printer libs; features depend on the PrinterService API).
  Provider<PrinterService>(
    create: (ctx) => ThermalPrinterServiceImpl(logger: ctx.read<Talker>()),
    dispose: (_, service) => service.dispose(),
  ),

  // Database — the single, app-owned instance created in main() and disposed
  // here when the provider tree is torn down.
  Provider<AgoraDatabase>.value(value: database),

  // ---------------------------------------------------------------------------
  // LAN sync core infra (docs/features/01-lan-sync.md). Registered here —
  // same tier as AgoraDatabase/PrinterService — so OrdersFeature/
  // InventoryFeature can read SyncManager/DeviceId when they build their
  // repositories below. Harmless for a station that never pairs: SyncManager
  // is never `.start()`-ed, so nothing here opens a socket or a server.
  // ---------------------------------------------------------------------------
  Provider<DeviceId>.value(value: deviceId),
  Provider<SyncWebSocket>(
    create: (ctx) => SyncWebSocket(logger: ctx.read<Talker>()),
    dispose: (_, ws) => ws.dispose(),
  ),
  Provider<OutboxDao>(create: (ctx) => OutboxDao(ctx.read<AgoraDatabase>())),
  Provider<OutboxQueue>(create: (ctx) => OutboxQueue(dao: ctx.read())),
  Provider<ConnectivityMonitor>(create: (_) => ConnectivityMonitorImpl()),
  Provider<SyncManager>(
    create: (ctx) {
      final manager = SyncManager(
        outboxQueue: ctx.read<OutboxQueue>(),
        connectivity: ctx.read<ConnectivityMonitor>(),
        webSocket: ctx.read<SyncWebSocket>(),
        logger: ctx.read<Talker>(),
      );
      manager.registerHandler(
        OrderSyncHandler(webSocket: ctx.read<SyncWebSocket>()),
      );
      manager.registerHandler(
        StockSyncHandler(webSocket: ctx.read<SyncWebSocket>()),
      );
      manager.registerHandler(
        TicketStatusSyncHandler(webSocket: ctx.read<SyncWebSocket>()),
      );
      return manager;
    },
    dispose: (_, manager) => manager.stop(),
  ),

  // ---------------------------------------------------------------------------
  // App-level repositories + BLoCs
  // ---------------------------------------------------------------------------
  RepositoryProvider<FeatureFlagsRepository>(
    create: (ctx) => FeatureFlagsRepositoryImpl(
      persistenceService: ctx.read<PersistenceService>(),
      config: config,
    ),
  ),
  RepositoryProvider<BusinessProfileRepository>(
    create: (ctx) => BusinessProfileRepositoryImpl(
      persistenceService: ctx.read<PersistenceService>(),
    ),
  ),
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

  BlocProvider<FeatureFlagsCubit>(
    create: (ctx) =>
        FeatureFlagsCubit(repository: ctx.read<FeatureFlagsRepository>()),
  ),
  BlocProvider<BusinessProfileCubit>(
    create: (ctx) =>
        BusinessProfileCubit(repository: ctx.read<BusinessProfileRepository>()),
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

  // ---------------------------------------------------------------------------
  // Feature providers (each feature registers its own DAOs, repos and BLoCs)
  // ---------------------------------------------------------------------------
  ...const AuthFeature().providers,

  // Cross-cutting "wipe everything + return to onboarding" service (see
  // package:app_reset). Registered here — after Auth (AuthRepository) and
  // above (BusinessProfileRepository, PersistenceService) — so both
  // `feature_settings` (danger zone) and the root `AppRootListener` can read
  // it without either depending on `feature_onboarding`.
  RepositoryProvider<AppResetService>(
    create: (ctx) => AppResetServiceImpl(
      database: ctx.read<AgoraDatabase>(),
      businessProfileRepository: ctx.read<BusinessProfileRepository>(),
      authRepository: ctx.read<AuthRepository>(),
      persistenceService: ctx.read<PersistenceService>(),
      logger: ctx.read<Talker>(),
    ),
  ),

  for (final feature in _remainingFeatures) ...feature.providers,
];

// Order matters — some features read repositories registered by others, so
// this list must stay in dependency order (see inline comments). AuthFeature
// is registered separately above (before AppResetService); the rest follow
// in the same relative order they always have.
const List<AppFeature> _remainingFeatures = [
  OnboardingFeature(), // after Auth (reads AuthRepository) + profile repo
  SettingsFeature(),
  InventoryFeature(), // must be before Products (StocksDao)
  ProductsFeature(),
  DiscountsFeature(), // must be before Orders (CheckoutCubit reads DiscountsRepository)
  OrdersFeature(),
  WorkforceFeature(), // must be after Orders (WorkforceRepository reads OrdersRepository
  // for expected-cash-per-shift; docs/features/04-volunteer-shift-accountability.md)
  ReportsFeature(), // must be after Orders + Products (reads both) and Workforce (variance rollup)
  KitchenFeature(), // before Sync (reads TicketsDao)
  SyncFeature(), // must be last — reads OrdersDao/OrderItemsDao (Orders),
  // StocksDao/StockMovementsDao (Inventory) and TicketsDao (Kitchen), all
  // registered above
];
