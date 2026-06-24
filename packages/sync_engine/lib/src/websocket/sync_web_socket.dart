import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:talker/talker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'sync_message.dart';

/// Managed WebSocket client with topic-based subscriptions and exponential-backoff reconnection.
///
/// Protocol (JSON over WebSocket):
///   Client → Server: {"type":"subscribe","topic":"order:loc123"}
///   Client → Server: {"type":"unsubscribe","topic":"order:loc123"}
///   Client → Server: {"type":"ping"}
///   Server → Client: {"type":"message","topic":"order:loc123","event":"order.created","data":{...}}
///   Server → Client: {"type":"pong"}
class SyncWebSocket {
  SyncWebSocket({required Talker logger}) : _logger = logger;

  final Talker _logger;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _messageSub;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  String? _currentUrl;
  String? _currentToken;
  int _reconnectAttempts = 0;

  static const _pingInterval = Duration(seconds: 30);
  static const _maxReconnectDelaySecs = 30;

  final _statusController =
      StreamController<WebSocketConnectionStatus>.broadcast();
  final _messageController = StreamController<SyncMessage>.broadcast();

  /// Emits connection state changes.
  Stream<WebSocketConnectionStatus> get connectionStatus =>
      _statusController.stream;

  /// Emits inbound domain messages from the backend.
  Stream<SyncMessage> get messages => _messageController.stream;

  final Set<String> _subscribedTopics = {};

  // ------------------------------------------------------------------ public

  Future<void> connect(String url, String token) async {
    _currentUrl = url;
    _currentToken = token;
    _reconnectAttempts = 0;
    await _doConnect(url, token);
  }

  /// Subscribe to a backend topic. Re-sent automatically on reconnection.
  void subscribe(String topic) {
    _subscribedTopics.add(topic);
    _send({'type': 'subscribe', 'topic': topic});
  }

  void unsubscribe(String topic) {
    _subscribedTopics.remove(topic);
    _send({'type': 'unsubscribe', 'topic': topic});
  }

  Future<void> disconnect() async {
    _clearUrl();
    await _tearDown();
    _statusController.add(WebSocketConnectionStatus.disconnected);
  }

  void dispose() {
    _clearUrl();
    _tearDown();
    _statusController.close();
    _messageController.close();
  }

  // ------------------------------------------------------------------ private

  Future<void> _doConnect(String url, String token) async {
    _statusController.add(WebSocketConnectionStatus.connecting);

    try {
      final uri = Uri.parse(url).replace(queryParameters: {'token': token});
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _reconnectAttempts = 0;
      _statusController.add(WebSocketConnectionStatus.connected);
      _logger.info('[SyncWebSocket] connected to $url');

      // Resubscribe to all active topics after (re)connection.
      for (final topic in _subscribedTopics) {
        _send({'type': 'subscribe', 'topic': topic});
      }

      _startPing();

      _messageSub = _channel!.stream.listen(
        _handleRaw,
        onDone: _scheduleReconnect,
        onError: (Object e) {
          _logger.error('[SyncWebSocket] stream error: $e');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      _logger.error('[SyncWebSocket] connect failed: $e');
      _statusController.add(WebSocketConnectionStatus.disconnected);
      _scheduleReconnect();
    }
  }

  void _handleRaw(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      if (type == 'pong') return;

      if (type == 'message') {
        final topic = data['topic'] as String?;
        final event = data['event'] as String?;
        final payload = (data['data'] as Map?)?.cast<String, dynamic>() ?? {};

        if (topic != null && event != null) {
          _messageController.add(
            SyncMessage(topic: topic, event: event, data: payload),
          );
        }
      }
    } catch (e) {
      _logger.error('[SyncWebSocket] failed to parse message: $e');
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      _send({'type': 'ping'});
    });
  }

  void _scheduleReconnect() {
    _messageSub?.cancel();
    _pingTimer?.cancel();
    _messageSub = null;
    _statusController.add(WebSocketConnectionStatus.disconnected);

    if (_currentUrl == null) return;

    final delaySecs = min(
      _maxReconnectDelaySecs,
      pow(2, _reconnectAttempts).toInt(),
    ).clamp(1, _maxReconnectDelaySecs);

    _reconnectAttempts++;
    _logger.info(
      '[SyncWebSocket] reconnecting in ${delaySecs}s (attempt $_reconnectAttempts)',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySecs), () {
      if (_currentUrl != null && _currentToken != null) {
        _doConnect(_currentUrl!, _currentToken!);
      }
    });
  }

  void _send(Map<String, dynamic> message) {
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      _logger.error('[SyncWebSocket] send error: $e');
    }
  }

  void _clearUrl() {
    _currentUrl = null;
    _currentToken = null;
  }

  Future<void> _tearDown() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _messageSub?.cancel();
    _reconnectTimer = null;
    _pingTimer = null;
    _messageSub = null;
    await _channel?.sink.close();
    _channel = null;
  }
}
