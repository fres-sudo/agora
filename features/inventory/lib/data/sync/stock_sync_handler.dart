import 'package:sync_engine/sync_engine.dart';

/// Pushes a locally-recorded stock delta to the hub. Registered on the
/// app-wide `SyncManager` (`entityType: 'stock_movement'`) — see
/// `InventoryRepositoryImpl.adjustStock`, which is what actually enqueues
/// the outbox entries this handler drains.
///
/// Only deltas ever reach here (docs/features/01-lan-sync.md): `setStock`/
/// `initializeStock` are absolute writes and deliberately never go through
/// `safeSync`, so there is only one event this handler ever sends.
class StockSyncHandler implements SyncHandler {
  StockSyncHandler({required SyncWebSocket webSocket}) : _webSocket = webSocket;

  final SyncWebSocket _webSocket;

  @override
  String get entityType => 'stock_movement';

  @override
  Future<void> handle(OutboxEntry entry) async {
    await _webSocket.publish(
      topic: 'stock',
      event: 'stock.adjusted',
      data: entry.payload,
    );
  }
}
