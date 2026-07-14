import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'apply/hub_apply_handler.dart';
import 'pairing/pairing_token_service.dart';
import 'websocket/hub_broadcast_router.dart';
import 'websocket/hub_connection.dart';

const _jsonHeaders = {'content-type': 'application/json'};

/// The embedded LAN sync hub: one station's copy of `apps/agora` toggles
/// "Host this event" and runs this server in-process. Other stations pair
/// via [_handlePair] (`POST /pair`) and then connect over WebSocket
/// (`GET /sync?token=...`), speaking the protocol defined in
/// `package:sync_engine`'s `SyncWebSocket`.
///
/// This class only ever sees already-decoded JSON `Map<String, dynamic>`
/// payloads — it has no knowledge of `AgoraDatabase`/Drift/feature DAOs.
/// The actual "apply this write to the shared database" logic is supplied
/// by the caller as [HubApplyHandler]s (built in the app shell, which is
/// allowed to depend on `features/orders`/`features/inventory`; this
/// package, like every `packages/`, must not).
class HubServer {
  HubServer({
    required Map<String, HubApplyHandler> applyHandlers,
    required PairingTokenService pairingTokenService,
    required Talker logger,
  }) : _applyHandlers = applyHandlers,
       _pairingTokenService = pairingTokenService,
       _logger = logger;

  final Map<String, HubApplyHandler> _applyHandlers;
  final PairingTokenService _pairingTokenService;
  final Talker _logger;

  final _broadcastRouter = HubBroadcastRouter();
  final Set<HubConnection> _connections = {};
  final _connectedCountController = StreamController<int>.broadcast();

  HttpServer? _server;

  /// Emits the current count of paired stations whenever it changes.
  Stream<int> get connectedStationCount => _connectedCountController.stream;

  /// Starts listening on all interfaces. [port] `0` (the default) binds an
  /// ephemeral port; returns the actually-bound port for [HubAdvertiser] to
  /// advertise.
  Future<int> start({int port = 0}) async {
    final router = Router()
      ..post('/pair', _handlePair)
      ..get('/sync', _syncEndpoint());

    _server = await shelf_io.serve(router.call, InternetAddress.anyIPv4, port);
    _logger.info('[HubServer] listening on port ${_server!.port}');
    return _server!.port;
  }

  /// Disconnects every paired station, revokes all pairing tokens, and
  /// stops listening. Every station degrades to standalone per
  /// docs/features/01-lan-sync.md's acceptance criteria — this method
  /// doesn't need to coordinate that, each station's own `SyncWebSocket`
  /// reconnect-then-fail loop handles it.
  Future<void> stop() async {
    for (final connection in _connections.toList()) {
      await connection.close();
    }
    _connections.clear();
    _pairingTokenService.revokeAll();
    await _server?.close(force: true);
    _server = null;
    _emitConnectedCount();
  }

  // ------------------------------------------------------------------ pairing

  Future<Response> _handlePair(Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final pin = body['pin'] as String? ?? '';
      final deviceId = body['deviceId'] as String?;
      if (deviceId == null || deviceId.isEmpty) {
        return Response(
          HttpStatus.badRequest,
          body: jsonEncode({'message': 'deviceId is required'}),
          headers: _jsonHeaders,
        );
      }

      final connectionInfo =
          request.context['shelf.io.connection_info'] as HttpConnectionInfo?;
      final requesterKey = connectionInfo?.remoteAddress.address ?? 'unknown';

      final session = _pairingTokenService.issue(
        deviceId: deviceId,
        suppliedPin: pin,
        requesterKey: requesterKey,
      );

      return Response.ok(
        jsonEncode({
          'token': session.token,
          'expiresAt': session.expiresAt.toIso8601String(),
        }),
        headers: _jsonHeaders,
      );
    } on PairingException catch (e) {
      return Response.forbidden(
        jsonEncode({'message': e.message}),
        headers: _jsonHeaders,
      );
    } catch (e) {
      _logger.error('[HubServer] /pair failed: $e');
      return Response.internalServerError(
        body: jsonEncode({'message': 'malformed pairing request'}),
        headers: _jsonHeaders,
      );
    }
  }

  // ------------------------------------------------------------------ sync ws

  Handler _syncEndpoint() {
    return (Request request) {
      final token = request.url.queryParameters['token'];
      final deviceId = token == null
          ? null
          : _pairingTokenService.deviceIdForToken(token);
      if (deviceId == null) {
        return Response.forbidden(
          jsonEncode({'message': 'invalid or missing token'}),
          headers: _jsonHeaders,
        );
      }

      final wsHandler = webSocketHandler(
        (WebSocketChannel channel, String? protocol) =>
            _handleConnection(deviceId, channel),
      );
      return wsHandler(request);
    };
  }

  void _handleConnection(String deviceId, WebSocketChannel channel) {
    final connection = HubConnection(
      deviceId: deviceId,
      channel: channel,
      logger: _logger,
    );
    _connections.add(connection);
    _emitConnectedCount();
    _logger.info('[HubServer] station connected: $deviceId');

    connection.rawMessages.listen(
      (raw) => _handleFrame(connection, raw),
      onDone: () => _removeConnection(connection),
      onError: (Object e) {
        _logger.error('[HubServer] connection error for $deviceId: $e');
        _removeConnection(connection);
      },
    );
  }

  void _removeConnection(HubConnection connection) {
    _connections.remove(connection);
    _broadcastRouter.removeConnection(connection);
    _emitConnectedCount();
    _logger.info('[HubServer] station disconnected: ${connection.deviceId}');
  }

  void _emitConnectedCount() {
    if (!_connectedCountController.isClosed) {
      _connectedCountController.add(_connections.length);
    }
  }

  Future<void> _handleFrame(HubConnection connection, dynamic raw) async {
    try {
      final frame = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = frame['type'] as String?;

      switch (type) {
        case SyncFrameType.subscribe:
          final topic = frame['topic'] as String?;
          if (topic != null) _broadcastRouter.subscribe(connection, topic);
        case SyncFrameType.unsubscribe:
          final topic = frame['topic'] as String?;
          if (topic != null) _broadcastRouter.unsubscribe(connection, topic);
        case SyncFrameType.ping:
          connection.send({'type': SyncFrameType.pong});
        case SyncFrameType.publish:
          await _handlePublish(connection, frame);
        default:
          _logger.warning(
            '[HubServer] unknown frame type "$type" from ${connection.deviceId}',
          );
      }
    } catch (e) {
      _logger.error(
        '[HubServer] failed to parse frame from ${connection.deviceId}: $e',
      );
    }
  }

  Future<void> _handlePublish(
    HubConnection connection,
    Map<String, dynamic> frame,
  ) async {
    final id = frame['id'] as String?;
    final topic = frame['topic'] as String?;
    final event = frame['event'] as String?;
    final data = (frame['data'] as Map?)?.cast<String, dynamic>() ?? {};

    if (id == null || topic == null || event == null) {
      connection.send({
        'type': SyncFrameType.error,
        'id': id,
        'message': 'malformed publish frame',
      });
      return;
    }

    final handler = _applyHandlers[topic];
    if (handler == null) {
      connection.send({
        'type': SyncFrameType.error,
        'id': id,
        'message': 'no handler for topic "$topic"',
      });
      return;
    }

    try {
      final broadcastData = await handler.apply(
        originDeviceId: connection.deviceId,
        event: event,
        data: data,
      );
      connection.send({'type': SyncFrameType.ack, 'id': id});
      _broadcastRouter.broadcast(
        topic: topic,
        event: event,
        data: broadcastData,
      );
    } catch (e) {
      _logger.error('[HubServer] apply failed for $topic/$event: $e');
      connection.send({
        'type': SyncFrameType.error,
        'id': id,
        'message': e.toString(),
      });
    }
  }
}
