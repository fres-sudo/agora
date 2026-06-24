import 'model/outbox_entry.dart';

/// Implemented by each feature to handle its entity type during outbox draining.
///
/// Register with [SyncManager.registerHandler]. The manager calls [handle] for
/// every pending [OutboxEntry] whose [OutboxEntry.entityType] matches [entityType].
abstract interface class SyncHandler {
  /// Logical entity name this handler processes (e.g. `'order'`, `'order_item'`).
  String get entityType;

  /// Push a single entry to the backend.
  ///
  /// Throw on failure — the engine will catch, mark the entry as failed, and
  /// schedule a retry with exponential backoff.
  Future<void> handle(OutboxEntry entry);
}
