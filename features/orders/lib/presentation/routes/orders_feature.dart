import 'package:database/database.dart';
import 'package:feature_orders/data/repositories/order_items_repository_impl.dart';
import 'package:feature_orders/data/repositories/orders_repository_impl.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/domain/repositories/order_items_repository.dart';
import 'package:order_management/repositories/orders_repository.dart';
import 'package:order_management/blocs/active_order/active_order_bloc.dart';
import 'package:order_management/blocs/checkout/checkout_cubit.dart';
import 'package:feature_orders/presentation/blocs/orders/orders_bloc.dart';
import 'package:discounts/repositories/discounts_repository.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:printing/printing.dart';
import 'package:talker/talker.dart';

class OrdersFeature extends AppFeature {
  const OrdersFeature();

  @override
  List<SingleChildWidget> get providers => [
    // DAOs
    ProxyProvider<AgoraDatabase, OrdersDao>(
      update: (_, db, _) => OrdersDao(db),
    ),
    ProxyProvider<AgoraDatabase, OrderItemsDao>(
      update: (_, db, _) => OrderItemsDao(db),
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
      create: (ctx) => ActiveOrderBloc(
        ordersRepository: ctx.read(),
        settingsCubit: ctx.read<SettingsCubit>(),
      ),
    ),
    BlocProvider<CheckoutCubit>(
      create: (ctx) => CheckoutCubit(
        ordersRepository: ctx.read(),
        inventoryRepository: ctx.read<InventoryRepository>(),
        productsRepository: ctx.read<ProductsRepository>(),
        discountsRepository: ctx.read<DiscountsRepository>(),
        printerService: ctx.read<PrinterService>(),
        logger: ctx.read<Talker>(),
      ),
    ),
  ];
}
