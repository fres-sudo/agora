import 'package:database/database.dart';
import 'package:feature_products/data/repositories/categories_repository_impl.dart';
import 'package:feature_products/data/repositories/combos_repository_impl.dart';
import 'package:feature_products/data/repositories/modifiers_repository_impl.dart';
import 'package:feature_products/data/repositories/products_repository_impl.dart';
import 'package:feature_products/data/sources/local/daos/categories_dao.dart';
import 'package:feature_products/data/sources/local/daos/combos_dao.dart';
import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/combos_repository.dart';
import 'package:catalog/repositories/modifiers_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:catalog/blocs/categories/categories_bloc.dart';
import 'package:catalog/blocs/combos/combos_bloc.dart';
import 'package:catalog/blocs/modifiers/modifiers_bloc.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:inventory_contracts/inventory_contracts.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class ProductsFeature extends AppFeature {
  const ProductsFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, ProductsDao>(
      update: (_, db, _) => ProductsDao(db),
    ),
    ProxyProvider<AgoraDatabase, CategoriesDao>(
      update: (_, db, _) => CategoriesDao(db),
    ),
    ProxyProvider<AgoraDatabase, ModifiersDao>(
      update: (_, db, _) => ModifiersDao(db),
    ),
    ProxyProvider<AgoraDatabase, CombosDao>(
      update: (_, db, _) => CombosDao(db),
    ),
    // Repositories
    // Stock is owned by `feature_inventory` — read its public
    // `InventoryRepository` (registered before Products; see
    // apps/agora/lib/app/app_providers.dart) rather than depending on its
    // `StocksDao` directly (see GitHub issue #4).
    RepositoryProvider<ProductsRepository>(
      create: (ctx) => ProductsRepositoryImpl(
        logger: ctx.read<Talker>(),
        productsDao: ctx.read(),
        inventoryRepository: ctx.read<InventoryRepository>(),
        modifiersDao: ctx.read(),
      ),
    ),
    RepositoryProvider<CategoriesRepository>(
      create: (ctx) => CategoriesRepositoryImpl(
        logger: ctx.read<Talker>(),
        categoriesDao: ctx.read(),
      ),
    ),
    RepositoryProvider<ModifiersRepository>(
      create: (ctx) => ModifiersRepositoryImpl(
        logger: ctx.read<Talker>(),
        modifiersDao: ctx.read(),
      ),
    ),
    RepositoryProvider<CombosRepository>(
      create: (ctx) => CombosRepositoryImpl(
        logger: ctx.read<Talker>(),
        combosDao: ctx.read(),
      ),
    ),
    // BLoCs
    BlocProvider<ProductsBloc>(
      create: (ctx) => ProductsBloc(
        productsRepository: ctx.read(),
        categoriesRepository: ctx.read(),
      ),
    ),
    BlocProvider<CategoriesBloc>(
      create: (ctx) => CategoriesBloc(categoriesRepository: ctx.read()),
    ),
    BlocProvider<ModifiersBloc>(
      create: (ctx) => ModifiersBloc(modifiersRepository: ctx.read()),
    ),
    BlocProvider<CombosBloc>(
      create: (ctx) => CombosBloc(combosRepository: ctx.read()),
    ),
  ];
}
