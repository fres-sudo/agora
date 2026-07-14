import 'package:sync_engine/sync_engine.dart';

import 'hub_connection.dart';

/// Tracks which [HubConnection]s are subscribed to which topics and fans
/// out `message` frames to them.
///
/// Broadcasts include the originating station (loopback design — see
/// `HostSessionController`'s doc comment): correctness against redelivery
/// relies on the receiving side's dedupe-on-syncId, not on the router
/// excluding the sender.
class HubBroadcastRouter {
  final Map<String, Set<HubConnection>> _subscribers = {};

  void subscribe(HubConnection connection, String topic) {
    connection.subscribedTopics.add(topic);
    _subscribers.putIfAbsent(topic, () => {}).add(connection);
  }

  void unsubscribe(HubConnection connection, String topic) {
    connection.subscribedTopics.remove(topic);
    _subscribers[topic]?.remove(connection);
  }

  /// Removes [connection] from every topic it was subscribed to — call
  /// when a connection closes.
  void removeConnection(HubConnection connection) {
    for (final topic in connection.subscribedTopics.toList()) {
      _subscribers[topic]?.remove(connection);
    }
  }

  void broadcast({
    required String topic,
    required String event,
    required Map<String, dynamic> data,
  }) {
    final frame = {
      'type': SyncFrameType.message,
      'topic': topic,
      'event': event,
      'data': data,
    };
    for (final connection in _subscribers[topic] ?? const <HubConnection>{}) {
      connection.send(frame);
    }
  }
}
