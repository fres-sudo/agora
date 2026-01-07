part of 'dependency_injector.dart';

final List<BlocProvider> _blocs = [
  // Core
  BlocProvider<ThemeCubit>(
    create: (context) =>
        ThemeCubit(persistenceService: context.read<PersistenceService>())
          ..load(),
  ),
  BlocProvider<VersionCheckerBloc>(
    create: (context) => VersionCheckerBloc(
      versionCheckerRepository: context.read<VersionCheckerRepository>(),
    ),
  ),
  BlocProvider<UrlLauncherBloc>(
    create: (context) => UrlLauncherBloc(
      urlLauncherRepository: context.read<UrlLauncherRepository>(),
    ),
  ),
  BlocProvider<SessionCubit>(
    create: (context) => SessionCubit(context.read<AuthRepository>()),
  ),
  BlocProvider<ConfigCubit>(
    create: (context) =>
        ConfigCubit(configRepository: context.read<ConfigRepository>()),
  ),

  // Products
  BlocProvider<ProductsBloc>(
    create: (context) => ProductsBloc(
      productsRepository: context.read<ProductsRepository>(),
      categoriesRepository: context.read<CategoriesRepository>(),
    ),
  ),
  BlocProvider<CategoriesBloc>(
    create: (context) => CategoriesBloc(
      categoriesRepository: context.read<CategoriesRepository>(),
    ),
  ),
  BlocProvider<ModifiersBloc>(
    create: (context) => ModifiersBloc(
      modifiersRepository: context.read<ModifiersRepository>(),
    ),
  ),

  // Orders
  BlocProvider<OrdersBloc>(
    create: (context) => OrdersBloc(
      ordersRepository: context.read<OrdersRepository>(),
    ),
  ),
  BlocProvider<ActiveOrderBloc>(
    create: (context) => ActiveOrderBloc(
      ordersRepository: context.read<OrdersRepository>(),
    ),
  ),

  // Inventory
  BlocProvider<InventoryBloc>(
    create: (context) => InventoryBloc(
      inventoryRepository: context.read<InventoryRepository>(),
    ),
  ),

  // Discounts
  BlocProvider<DiscountsBloc>(
    create: (context) => DiscountsBloc(
      discountsRepository: context.read<DiscountsRepository>(),
    ),
  ),

  // Settings
  BlocProvider<SettingsCubit>(
    create: (context) => SettingsCubit(
      settingsRepository: context.read<SettingsRepository>(),
    )..load(),
  ),
];
