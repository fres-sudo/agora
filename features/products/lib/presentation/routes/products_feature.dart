import 'package:database/database.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_products/data/repositories/categories_repository_impl.dart';
import 'package:feature_products/data/repositories/modifiers_repository_impl.dart';
import 'package:feature_products/data/repositories/products_repository_impl.dart';
import 'package:feature_products/data/sources/local/daos/categories_dao.dart';
import 'package:feature_products/data/sources/local/daos/modifiers_dao.dart';
import 'package:feature_products/data/sources/local/daos/products_dao.dart';
import 'package:feature_products/domain/repositories/categories_repository.dart';
import 'package:feature_products/domain/repositories/modifiers_repository.dart';
import 'package:feature_products/domain/repositories/products_repository.dart';
import 'package:feature_products/presentation/blocs/categories/categories_bloc.dart';
import 'package:feature_products/presentation/blocs/modifiers/modifiers_bloc.dart';
import 'package:feature_products/presentation/blocs/products/products_bloc.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class ProductsFeature {
  static List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, ProductsDao>(
      update: (_, db, _) =>ProductsDao(db),
    ),
    ProxyProvider<AgoraDatabase, CategoriesDao>(
      update: (_, db, _) =>CategoriesDao(db),
    ),
    ProxyProvider<AgoraDatabase, ModifiersDao>(
      update: (_, db, _) =>ModifiersDao(db),
    ),
    ProxyProvider<AgoraDatabase, StocksDao>(
      update: (_, db, _) =>StocksDao(db),
    ),
    // Repositories
    RepositoryProvider<ProductsRepository>(
      create: (ctx) => ProductsRepositoryImpl(
        logger: ctx.read<Talker>(),
        productsDao: ctx.read(),
        stocksDao: ctx.read(),
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
  ];
}
