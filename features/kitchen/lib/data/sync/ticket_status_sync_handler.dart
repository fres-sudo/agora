import 'package:sync_engine/sync_engine.dart';

/// Pushes a locally-advanced ticket status to the hub. Registered on the
/// app-wide `SyncManager` (`entityType: 'ticket_status'`) — see
/// `TicketsRepositoryImpl.advanceTicket`, which is what actually enqueues
/// the outbox entries this handler drains.
class TicketStatusSyncHandler implements SyncHandler {
  TicketStatusSyncHandler({required SyncWebSocket webSocket})
    : _webSocket = webSocket;

  final SyncWebSocket _webSocket;

  @override
  String get entityType => 'ticket_status';

  @override
  Future<void> handle(OutboxEntry entry) async {
    await _webSocket.publish(
      topic: 'tickets',
      event: 'ticket.status_changed',
      data: entry.payload,
    );
  }
}
