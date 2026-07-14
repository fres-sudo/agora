/// Applies an inbound published event from a paired station to the host's
/// own `AgoraDatabase` — the embedded hub's shared source of truth.
///
/// One implementation per topic (`orders`, `stock`). Idempotent: the same
/// event redelivered (including the host's own loopback publish, see
/// `HostSessionController`) must be a safe no-op, deduped on the event's
/// `syncId`.
abstract interface class HubApplyHandler {
  /// The topic this handler applies events for, e.g. `'orders'`.
  String get topic;

  /// Applies [event]/[data] (already validated as JSON) to the local
  /// database. Returns the data to broadcast onward to other subscribed
  /// stations — normally [data] unchanged. Throws to reject the write; the
  /// caller replies with an `error` frame and never broadcasts.
  Future<Map<String, dynamic>> apply({
    required String originDeviceId,
    required String event,
    required Map<String, dynamic> data,
  });
}
