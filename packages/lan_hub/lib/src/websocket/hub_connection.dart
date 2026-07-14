import 'dart:convert';

import 'package:talker/talker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// One paired station's live connection to the embedded hub.
class HubConnection {
  HubConnection({
    required this.deviceId,
    required WebSocketChannel channel,
    required Talker logger,
  }) : _channel = channel,
       _logger = logger;

  /// The station's stable install identity, resolved from its pairing
  /// token (see `PairingTokenService.deviceIdForToken`) — never trusted
  /// from a client-supplied frame field.
  final String deviceId;

  final WebSocketChannel _channel;
  final Talker _logger;

  /// Topics this connection is currently subscribed to.
  final Set<String> subscribedTopics = {};

  Stream<dynamic> get rawMessages => _channel.stream;

  void send(Map<String, dynamic> frame) {
    try {
      _channel.sink.add(jsonEncode(frame));
    } catch (e) {
      _logger.error('[HubConnection] send failed for $deviceId: $e');
    }
  }

  Future<void> close() => _channel.sink.close();
}
