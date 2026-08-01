import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:feature_settings/data/repositories/catalog_templates_repository_impl.dart';
import 'package:feature_settings/data/repositories/public_menu_repository_impl.dart';
import 'package:feature_settings/data/repositories/settings_repository_impl.dart';
import 'package:feature_settings/data/sources/remote/public_menu_remote_data_source.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:feature_settings/data/sources/local/daos/catalog_templates_dao.dart';
import 'package:feature_settings/presentation/blocs/catalog_templates_cubit.dart';
import 'package:feature_settings/presentation/blocs/public_menu_cubit.dart';
import 'package:feature_settings/domain/repositories/public_menu_repository.dart';
import 'package:app_settings/repositories/settings_repository.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:catalog/repositories/catalog_templates_repository.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/combos_repository.dart';
import 'package:catalog/repositories/modifiers_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:talker/talker.dart';

class SettingsFeature extends AppFeature {
  const SettingsFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, AppSettingsDao>(
      update: (_, db, _) => AppSettingsDao(db),
    ),
    ProxyProvider<AgoraDatabase, CatalogTemplatesDao>(
      update: (_, db, _) => CatalogTemplatesDao(db),
    ),
    // Repositories
    RepositoryProvider<SettingsRepository>(
      create: (ctx) => SettingsRepositoryImpl(
        logger: ctx.read<Talker>(),
        appSettingsDao: ctx.read(),
      ),
    ),
    // Reads Categories/Products/Modifiers/CombosRepository, registered by
    // `ProductsFeature` — this feature must be registered after it (see
    // apps/agora/lib/app/app_providers.dart).
    RepositoryProvider<CatalogTemplatesRepository>(
      create: (ctx) => CatalogTemplatesRepositoryImpl(
        logger: ctx.read<Talker>(),
        catalogTemplatesDao: ctx.read(),
        database: ctx.read<AgoraDatabase>(),
        categoriesRepository: ctx.read<CategoriesRepository>(),
        productsRepository: ctx.read<ProductsRepository>(),
        modifiersRepository: ctx.read<ModifiersRepository>(),
        combosRepository: ctx.read<CombosRepository>(),
      ),
    ),
    RepositoryProvider<PublicMenuRepository>(
      create: (ctx) => PublicMenuRepositoryImpl(
        logger: ctx.read<Talker>(),
        settingsRepository: ctx.read<SettingsRepository>(),
        categoriesRepository: ctx.read<CategoriesRepository>(),
        productsRepository: ctx.read<ProductsRepository>(),
        combosRepository: ctx.read<CombosRepository>(),
        secureStorage: ctx.read<FlutterSecureStorage>(),
        remoteDataSource: PublicMenuRemoteDataSource(
          dio: ctx.read<Dio>(),
          baseUrl: ctx.read<AppConfig>().publicMenuApiBaseUrl,
        ),
      ),
    ),
    // BLoCs
    BlocProvider<SettingsCubit>(
      create: (ctx) => SettingsCubit(settingsRepository: ctx.read())..load(),
    ),
    BlocProvider<CatalogTemplatesCubit>(
      create: (ctx) =>
          CatalogTemplatesCubit(catalogTemplatesRepository: ctx.read()),
    ),
    BlocProvider<PublicMenuCubit>(
      create: (ctx) => PublicMenuCubit(publicMenuRepository: ctx.read()),
    ),
  ];
}
