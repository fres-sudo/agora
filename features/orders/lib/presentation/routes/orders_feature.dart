import 'package:database/database.dart';
import 'package:feature_orders/data/repositories/order_items_repository_impl.dart';
import 'package:feature_orders/data/repositories/orders_repository_impl.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/domain/repositories/order_items_repository.dart';
import 'package:feature_orders/domain/repositories/orders_repository.dart';
import 'package:feature_orders/presentation/blocs/active_order/active_order_bloc.dart';
import 'package:feature_orders/presentation/blocs/orders/orders_bloc.dart';
import 'package:feature_inventory/domain/repositories/inventory_repository.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:talker/talker.dart';

class OrdersFeature {
  static List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, OrdersDao>(
      update: (_, db, _) =>OrdersDao(db),
    ),
    ProxyProvider<AgoraDatabase, OrderItemsDao>(
      update: (_, db, _) =>OrderItemsDao(db),
    ),
    // Repositories
    RepositoryProvider<OrdersRepository>(
      create: (ctx) => OrdersRepositoryImpl(
        logger: ctx.read<Talker>(),
        ordersDao: ctx.read(),
        orderItemsDao: ctx.read(),
      ),
    ),
    RepositoryProvider<OrderItemsRepository>(
      create: (ctx) => OrderItemsRepositoryImpl(
        logger: ctx.read<Talker>(),
        orderItemsDao: ctx.read(),
      ),
    ),
    // BLoCs
    BlocProvider<OrdersBloc>(
      create: (ctx) => OrdersBloc(
        ordersRepository: ctx.read(),
        inventoryRepository: ctx.read<InventoryRepository>(),
      ),
    ),
    BlocProvider<ActiveOrderBloc>(
      create: (ctx) => ActiveOrderBloc(ordersRepository: ctx.read()),
    ),
  ];
}
