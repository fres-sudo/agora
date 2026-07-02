import 'package:database/database.dart';
import 'package:feature_inventory/data/repositories/inventory_repository_impl.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:feature_inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:feature_inventory/presentation/blocs/stock_adjustment/stock_adjustment_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class InventoryFeature {
  static List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, StocksDao>(
      update: (_, db, _) =>StocksDao(db),
    ),
    ProxyProvider<AgoraDatabase, StockMovementsDao>(
      update: (_, db, _) =>StockMovementsDao(db),
    ),
    // Repository
    RepositoryProvider<InventoryRepository>(
      create: (ctx) => InventoryRepositoryImpl(
        logger: ctx.read<Talker>(),
        stocksDao: ctx.read(),
        stockMovementsDao: ctx.read(),
      ),
    ),
    // BLoCs
    BlocProvider<InventoryBloc>(
      create: (ctx) => InventoryBloc(inventoryRepository: ctx.read()),
    ),
    BlocProvider<StockAdjustmentCubit>(
      create: (ctx) => StockAdjustmentCubit(inventoryRepository: ctx.read()),
    ),
  ];
}
