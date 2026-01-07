part of 'dependency_injector.dart';

final List<RepositoryProvider<dynamic>> _repositories = [
  RepositoryProvider<VersionCheckerRepository>(
    create: (context) => VersionCheckerRepositoryImpl(
      versionCheckerService: context.read<VersionCheckerService>(),
    ),
  ),
  RepositoryProvider<UrlLauncherRepository>(
    create: (context) => UrlLauncherRepositoryImpl(
      urlLauncherService: context.read<UrlLauncherService>(),
    ),
  ),
  RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl()),
  RepositoryProvider<ConfigRepository>(
    create: (context) => ConfigRepositoryImpl(
      logger: context.read<Talker>(),
      service: context.read<ConfigService>(),
    ),
  ),

  // Products
  RepositoryProvider<ProductsRepository>(
    create: (context) => ProductsRepositoryImpl(
      logger: context.read<Talker>(),
      productsDao: context.read<ProductsDao>(),
      stocksDao: context.read<StocksDao>(),
    ),
  ),
  RepositoryProvider<CategoriesRepository>(
    create: (context) => CategoriesRepositoryImpl(
      logger: context.read<Talker>(),
      categoriesDao: context.read<CategoriesDao>(),
    ),
  ),
  RepositoryProvider<ModifiersRepository>(
    create: (context) => ModifiersRepositoryImpl(
      logger: context.read<Talker>(),
      modifiersDao: context.read<ModifiersDao>(),
    ),
  ),

  // Orders
  RepositoryProvider<OrdersRepository>(
    create: (context) => OrdersRepositoryImpl(
      logger: context.read<Talker>(),
      ordersDao: context.read<OrdersDao>(),
      orderItemsDao: context.read<OrderItemsDao>(),
    ),
  ),
  RepositoryProvider<OrderItemsRepository>(
    create: (context) => OrderItemsRepositoryImpl(
      logger: context.read<Talker>(),
      orderItemsDao: context.read<OrderItemsDao>(),
    ),
  ),

  // Inventory
  RepositoryProvider<InventoryRepository>(
    create: (context) => InventoryRepositoryImpl(
      logger: context.read<Talker>(),
      stocksDao: context.read<StocksDao>(),
      stockMovementsDao: context.read<StockMovementsDao>(),
    ),
  ),

  // Discounts
  RepositoryProvider<DiscountsRepository>(
    create: (context) => DiscountsRepositoryImpl(
      logger: context.read<Talker>(),
      discountsDao: context.read<DiscountsDao>(),
    ),
  ),

  // Settings
  RepositoryProvider<SettingsRepository>(
    create: (context) => SettingsRepositoryImpl(
      logger: context.read<Talker>(),
      appSettingsDao: context.read<AppSettingsDao>(),
    ),
  ),
];
