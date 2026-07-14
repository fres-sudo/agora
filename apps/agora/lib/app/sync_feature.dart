import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart' show AppFeature;
import 'package:database/database.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:feature_inventory/data/sync/stock_apply_handler.dart';
import 'package:feature_inventory/data/sync/stock_inbound_applier.dart';
import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:feature_kitchen/data/sync/ticket_apply_handler.dart';
import 'package:feature_kitchen/data/sync/ticket_inbound_applier.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/data/sync/order_apply_handler.dart';
import 'package:feature_orders/data/sync/order_inbound_applier.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

import 'sync_bootstrap.dart';

/// Cross-feature glue for LAN sync (docs/features/01-lan-sync.md): the
/// pairing/hosting infrastructure (`packages/lan_hub`) combined with
/// per-topic handlers that live inside `features/orders`,
/// `features/inventory` and `features/kitchen`
/// (docs/features/02-kitchen-ticket-routing.md). This lives in the app
/// shell rather than as its own `features/` package because it needs DAOs
/// from multiple features at once — a third feature importing the others
/// would violate the `features ↛ features` rule.
///
/// Registered **last** in `_remainingFeatures` (see app_providers.dart):
/// every provider it reads (`OrdersDao`, `OrderItemsDao`, `StocksDao`,
/// `StockMovementsDao`, `TicketsDao`, plus the core sync infra registered
/// earlier in `_buildProviders`) must already exist in the tree.
class SyncFeature extends AppFeature {
  const SyncFeature();

  @override
  List<SingleChildWidget> get providers => [
    Provider<PairingTokenService>(
      create: (ctx) => PairingTokenService(
        pinProvider: () =>
            ctx.read<SettingsCubit>().getString(SettingsKeys.syncPairingPin) ??
            '',
      ),
    ),
    Provider<HubServer>(
      create: (ctx) => HubServer(
        applyHandlers: {
          'orders': OrderApplyHandler(
            ordersDao: ctx.read<OrdersDao>(),
            orderItemsDao: ctx.read<OrderItemsDao>(),
            logger: ctx.read<Talker>(),
          ),
          'stock': StockApplyHandler(
            stocksDao: ctx.read<StocksDao>(),
            stockMovementsDao: ctx.read<StockMovementsDao>(),
            logger: ctx.read<Talker>(),
          ),
          'tickets': TicketApplyHandler(
            ticketsDao: ctx.read<TicketsDao>(),
            logger: ctx.read<Talker>(),
          ),
        },
        pairingTokenService: ctx.read<PairingTokenService>(),
        logger: ctx.read<Talker>(),
      ),
    ),
    Provider<HubAdvertiser>(
      create: (ctx) => HubAdvertiser(logger: ctx.read<Talker>()),
    ),
    Provider<HubDiscovery>(
      create: (ctx) => HubDiscovery(logger: ctx.read<Talker>()),
    ),
    Provider<HubPairingClient>(
      create: (ctx) => HubPairingClient(logger: ctx.read<Talker>()),
    ),
    Provider<HostSessionController>(
      create: (ctx) => HostSessionController(
        hubServer: ctx.read<HubServer>(),
        hubAdvertiser: ctx.read<HubAdvertiser>(),
        syncManager: ctx.read<SyncManager>(),
        pairingTokenService: ctx.read<PairingTokenService>(),
        deviceId: ctx.read<DeviceId>().value,
        logger: ctx.read<Talker>(),
      ),
    ),
    Provider<SyncBootstrap>(
      create: (ctx) => SyncBootstrap(
        syncManager: ctx.read<SyncManager>(),
        orderApplier: OrderInboundApplier(
          ordersDao: ctx.read<OrdersDao>(),
          orderItemsDao: ctx.read<OrderItemsDao>(),
          logger: ctx.read<Talker>(),
        ),
        stockApplier: StockInboundApplier(
          stocksDao: ctx.read<StocksDao>(),
          stockMovementsDao: ctx.read<StockMovementsDao>(),
          logger: ctx.read<Talker>(),
        ),
        ticketApplier: TicketInboundApplier(
          ticketsDao: ctx.read<TicketsDao>(),
          logger: ctx.read<Talker>(),
        ),
        logger: ctx.read<Talker>(),
      ),
    ),
  ];
}
