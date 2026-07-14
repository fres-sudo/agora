import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:feature_orders/data/sync/order_inbound_applier.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// The host-side counterpart of [OrderInboundApplier] — registered into
/// `HubServer.applyHandlers['orders']` (in the app shell, see
/// `apps/agora/lib/app/sync_feature.dart`) so a `publish` frame from any
/// paired station gets applied to the host's own database exactly the same
/// way an inbound broadcast would be. `features/orders` may depend on
/// `packages/lan_hub` (features → packages is allowed); `lan_hub` itself
/// never depends back on any feature.
class OrderApplyHandler implements HubApplyHandler {
  OrderApplyHandler({
    required OrdersDao ordersDao,
    required OrderItemsDao orderItemsDao,
    required Talker logger,
  }) : _applier = OrderInboundApplier(
         ordersDao: ordersDao,
         orderItemsDao: orderItemsDao,
         logger: logger,
       );

  final OrderInboundApplier _applier;

  @override
  String get topic => 'orders';

  @override
  Future<Map<String, dynamic>> apply({
    required String originDeviceId,
    required String event,
    required Map<String, dynamic> data,
  }) async {
    await _applier.apply(
      SyncMessage(topic: 'orders', event: event, data: data),
    );
    return data;
  }
}
