/// A message received from the backend over the WebSocket.
class SyncMessage {
  const SyncMessage({
    required this.topic,
    required this.event,
    required this.data,
  });

  /// The topic this message was broadcast on (e.g. `order:loc123`).
  final String topic;

  /// Domain event name (e.g. `order.created`, `order.status_changed`).
  final String event;

  /// Arbitrary payload from the backend.
  final Map<String, dynamic> data;

  @override
  String toString() => 'SyncMessage(topic: $topic, event: $event)';
}

enum WebSocketConnectionStatus { disconnected, connecting, connected }
