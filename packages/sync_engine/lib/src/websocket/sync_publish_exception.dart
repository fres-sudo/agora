/// Thrown by [SyncWebSocket.publish] when the hub replies with an `error`
/// frame instead of an `ack` — e.g. the hub's apply handler rejected the
/// write. Caught by [SyncManager]'s drain loop exactly like any other
/// [SyncHandler.handle] failure, so it feeds the normal retry/backoff path.
class SyncPublishException implements Exception {
  SyncPublishException(this.message);

  final String message;

  @override
  String toString() => 'SyncPublishException: $message';
}
