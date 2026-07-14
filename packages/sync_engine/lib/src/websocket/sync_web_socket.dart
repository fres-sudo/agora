import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:talker/talker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'sync_message.dart';
import 'sync_protocol.dart';
import 'sync_publish_exception.dart';

/// Managed WebSocket client with topic-based subscriptions and exponential-backoff reconnection.
///
/// Protocol (JSON over WebSocket):
///   Client → Server: {"type":"subscribe","topic":"orders"}
///   Client → Server: {"type":"unsubscribe","topic":"orders"}
///   Client → Server: {"type":"ping"}
///   Client → Server: {"type":"publish","id":"(correlation id)","topic":"orders","event":"order.created","data":{...}}
///   Server → Client: {"type":"message","topic":"orders","event":"order.created","data":{...}}
///   Server → Client: {"type":"pong"}
///   Server → Client: {"type":"ack","id":"(correlation id)"}
///   Server → Client: {"type":"error","id":"(correlation id)","message":"..."}
class SyncWebSocket {
  SyncWebSocket({
    required Talker logger,
    Duration pingInterval = const Duration(seconds: 30),
    int maxReconnectDelaySecs = 30,
  }) : _logger = logger,
       _pingInterval = pingInterval,
       _maxReconnectDelaySecs = maxReconnectDelaySecs;

  final Talker _logger;
  final Duration _pingInterval;
  final int _maxReconnectDelaySecs;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _messageSub;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  String? _currentUrl;
  String? _currentToken;
  int _reconnectAttempts = 0;

  final _statusController =
      StreamController<WebSocketConnectionStatus>.broadcast();
  final _messageController = StreamController<SyncMessage>.broadcast();

  /// Emits connection state changes.
  Stream<WebSocketConnectionStatus> get connectionStatus =>
      _statusController.stream;

  /// Emits inbound domain messages from the backend.
  Stream<SyncMessage> get messages => _messageController.stream;

  final Set<String> _subscribedTopics = {};

  final Map<String, Completer<void>> _pendingPublishes = {};
  int _correlationSeq = 0;

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
    _send({'type': SyncFrameType.subscribe, 'topic': topic});
  }

  void unsubscribe(String topic) {
    _subscribedTopics.remove(topic);
    _send({'type': SyncFrameType.unsubscribe, 'topic': topic});
  }

  /// Pushes a local write to the hub and waits for its `ack`/`error` reply.
  ///
  /// Resolves once the hub acknowledges the write; throws
  /// [SyncPublishException] if the hub rejects it, or [TimeoutException] if
  /// no reply arrives within [timeout]. Both are ordinary exceptions from
  /// [SyncHandler.handle]'s point of view — [SyncManager]'s drain loop
  /// catches them and retries via [RetryBackoff] like any other failure.
  Future<void> publish({
    required String topic,
    required String event,
    required Map<String, dynamic> data,
    Duration timeout = const Duration(seconds: 3),
  }) {
    final id = '${DateTime.now().microsecondsSinceEpoch}_${_correlationSeq++}';
    final completer = Completer<void>();
    _pendingPublishes[id] = completer;

    _send({
      'type': SyncFrameType.publish,
      'id': id,
      'topic': topic,
      'event': event,
      'data': data,
    });

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _pendingPublishes.remove(id);
        throw TimeoutException(
          'publish($topic/$event) timed out waiting for ack',
          timeout,
        );
      },
    );
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
        _send({'type': SyncFrameType.subscribe, 'topic': topic});
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

      if (type == SyncFrameType.pong) return;

      if (type == SyncFrameType.ack) {
        final id = data['id'] as String?;
        _pendingPublishes.remove(id)?.complete();
        return;
      }

      if (type == SyncFrameType.error) {
        final id = data['id'] as String?;
        _pendingPublishes
            .remove(id)
            ?.completeError(
              SyncPublishException(
                data['message'] as String? ?? 'unknown error',
              ),
            );
        return;
      }

      if (type == SyncFrameType.message) {
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
      _send({'type': SyncFrameType.ping});
    });
  }

  void _scheduleReconnect() {
    _messageSub?.cancel();
    _pingTimer?.cancel();
    _messageSub = null;
    _statusController.add(WebSocketConnectionStatus.disconnected);
    _failAllPending(StateError('WebSocket disconnected'));

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

  void _failAllPending(Object error) {
    for (final completer in _pendingPublishes.values) {
      if (!completer.isCompleted) completer.completeError(error);
    }
    _pendingPublishes.clear();
  }

  Future<void> _tearDown() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _messageSub?.cancel();
    _reconnectTimer = null;
    _pingTimer = null;
    _messageSub = null;
    _failAllPending(StateError('WebSocket disconnected'));
    await _channel?.sink.close();
    _channel = null;
  }
}
