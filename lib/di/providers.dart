part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<Talker>(create: (_) => Talker()),
  Provider<VersionCheckerService>(create: (_) => VersionCheckerServiceImpl()),
  Provider<UrlLauncherService>(
    create: (context) => UrlLauncherServiceImpl(
      launchModeMapper: context.read<LaunchModeMapper>(),
    ),
  ),
  Provider<PersistenceService>(create: (_) => PersistenceServiceImpl()),
  Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
  Provider<Dio>(
    create: (context) {
      final dio = Dio(BaseOptions(contentType: 'application/json'));
      final talkerDioLogger = TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: true,
        ),
      );
      // NOTE: add other interceptors here
      dio.interceptors.addAll([talkerDioLogger]);
      return dio;
    },
  ),
  Provider<ConfigService>(create: (context) => ConfigServiceImpl()),

  // Database
  Provider<AgoraDatabase>(
    create: (_) => AgoraDatabase(driftDatabase(name: K.dbName)),
    dispose: (_, db) => db.close(),
  ),

  // DAOs
  ProxyProvider<AgoraDatabase, ProductsDao>(
    update: (context, db, _) => db.productsDao,
  ),
  ProxyProvider<AgoraDatabase, CategoriesDao>(
    update: (context, db, _) => db.categoriesDao,
  ),
  ProxyProvider<AgoraDatabase, ModifiersDao>(
    update: (context, db, _) => db.modifiersDao,
  ),
  ProxyProvider<AgoraDatabase, StocksDao>(
    update: (context, db, _) => db.stocksDao,
  ),
  ProxyProvider<AgoraDatabase, StockMovementsDao>(
    update: (context, db, _) => db.stockMovementsDao,
  ),
  ProxyProvider<AgoraDatabase, OrdersDao>(
    update: (context, db, _) => db.ordersDao,
  ),
  ProxyProvider<AgoraDatabase, OrderItemsDao>(
    update: (context, db, _) => db.orderItemsDao,
  ),
  ProxyProvider<AgoraDatabase, DiscountsDao>(
    update: (context, db, _) => db.discountsDao,
  ),
  ProxyProvider<AgoraDatabase, AppSettingsDao>(
    update: (context, db, _) => db.appSettingsDao,
  ),
];
