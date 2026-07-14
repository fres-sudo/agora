import 'package:database/database.dart';
import 'package:feature_orders/data/sources/local/daos/order_items_dao.dart';
import 'package:feature_orders/data/sources/local/daos/orders_dao.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// Applies an `orders`-topic broadcast to the local `AgoraDatabase`,
/// bypassing `SyncableRepository.safeSync` entirely — an applied broadcast
/// must never re-enter this station's own outbox, or it would loop back to
/// the hub forever. Dedupes on `syncId` so redelivery (including the
/// host's own loopback broadcast of its own writes — see
/// `HostSessionController`) is a safe no-op.
///
/// Also the apply logic behind `OrderApplyHandler`, used by the host's
/// `HubServer` for exactly the same reason: whether a write originated
/// locally or from a peer, "apply this order data to the database" is one
/// piece of logic, not two.
class OrderInboundApplier {
  OrderInboundApplier({
    required OrdersDao ordersDao,
    required OrderItemsDao orderItemsDao,
    required Talker logger,
  }) : _ordersDao = ordersDao,
       _orderItemsDao = orderItemsDao,
       _logger = logger;

  final OrdersDao _ordersDao;
  final OrderItemsDao _orderItemsDao;
  final Talker _logger;

  Future<void> apply(SyncMessage message) async {
    final syncId = message.data['syncId'] as String?;
    if (syncId == null) {
      _logger.warning(
        '[OrderInboundApplier] message with no syncId — dropping',
      );
      return;
    }

    switch (message.event) {
      case 'order.created':
        await _applyCreate(syncId, message.data);
      case 'order.voided':
        await _applyVoid(syncId);
      default:
        _logger.warning(
          '[OrderInboundApplier] unknown event "${message.event}"',
        );
    }
  }

  Future<void> _applyCreate(String syncId, Map<String, dynamic> data) async {
    if (await _ordersDao.getOrderBySyncId(syncId) != null) {
      return; // Already applied — redelivery or our own loopback echo.
    }

    await _ordersDao.transaction(() async {
      final orderId = await _ordersDao.insertOrder(
        OrdersTableCompanion.insert(
          createdAt: Value(DateTime.parse(data['createdAt'] as String)),
          status: Value(data['status'] as int),
          orderType: Value(data['orderType'] as int),
          subtotal: data['subtotalCents'] as int,
          discountTotal: Value(data['discountCents'] as int),
          taxTotal: Value(data['taxCents'] as int),
          grandTotal: data['grandTotalCents'] as int,
          note: Value(data['note'] as String?),
          paymentMethod: Value(data['paymentMethod'] as String?),
          syncId: Value(syncId),
        ),
      );

      for (final rawItem in data['items'] as List) {
        final item = (rawItem as Map).cast<String, dynamic>();
        final itemId = await _orderItemsDao.insertOrderItem(
          OrderItemsTableCompanion.insert(
            orderId: orderId,
            productId: Value(item['productId'] as int?),
            productName: item['productName'] as String,
            unitPrice: item['unitPriceCents'] as int,
            costPrice: 0,
            quantity: Value(item['quantity'] as int),
            discountAmount: const Value(0),
            prepStation: Value(item['prepStation'] as String?),
          ),
        );

        for (final rawModifier in item['modifiers'] as List) {
          final modifier = (rawModifier as Map).cast<String, dynamic>();
          await _orderItemsDao.addModifierToOrderItem(
            orderItemId: itemId,
            modifierName: modifier['groupName'] as String,
            optionName: modifier['optionName'] as String,
            priceChange: modifier['priceChangeCents'] as int,
          );
        }
      }
    });
  }

  Future<void> _applyVoid(String syncId) async {
    final existing = await _ordersDao.getOrderBySyncId(syncId);
    if (existing == null) {
      // Accepted v1 risk (docs/features/01-lan-sync.md): a void arriving
      // before its create in a narrow cross-station race is logged and
      // dropped, not buffered/retried.
      _logger.warning(
        '[OrderInboundApplier] void for unknown syncId=$syncId — dropping',
      );
      return;
    }
    await _ordersDao.voidOrder(existing.id); // idempotent CAS
  }
}
