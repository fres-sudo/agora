import 'package:sync_engine/sync_engine.dart';

/// Pushes a locally-created or -voided order to the hub. Registered on the
/// app-wide `SyncManager` (`entityType: 'order'`) — see
/// `OrdersRepositoryImpl.createOrder`/`voidOrder`, which are what actually
/// enqueue the outbox entries this handler drains.
///
/// Orders are append-only (docs/features/01-lan-sync.md): the only two
/// events that ever exist are `order.created` and `order.voided`, derived
/// directly from the outbox entry's operation — never a generic "update".
class OrderSyncHandler implements SyncHandler {
  OrderSyncHandler({required SyncWebSocket webSocket}) : _webSocket = webSocket;

  final SyncWebSocket _webSocket;

  @override
  String get entityType => 'order';

  @override
  Future<void> handle(OutboxEntry entry) async {
    final event = switch (entry.operation) {
      OutboxOperation.create => 'order.created',
      OutboxOperation.update => 'order.voided',
      OutboxOperation.delete => throw StateError(
        'orders are append-only — a delete should never reach the outbox',
      ),
    };
    await _webSocket.publish(
      topic: 'orders',
      event: event,
      data: entry.payload,
    );
  }
}
