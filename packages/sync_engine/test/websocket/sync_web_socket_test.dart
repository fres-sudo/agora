@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// A minimal real WebSocket server (dart:io, no fakes/mocks) so these tests
/// exercise [SyncWebSocket]'s actual wire behavior — framing, reconnect,
/// and the new publish/ack/error correlation — end to end, not through a
/// stub. This is the class with 0% prior coverage per the LAN sync plan.
///
/// [nextConnection] is queue-based rather than `Stream.first` on a
/// broadcast controller: a connection can arrive before the test starts
/// awaiting for it (the client's own `connect()` future resolves as soon
/// as *its* handshake completes, with no ordering guarantee relative to
/// this server's async request callback), and a broadcast stream silently
/// drops events with no listener attached yet.
class _FakeHubServer {
  _FakeHubServer._(this._server);

  final HttpServer _server;
  final _buffered = <WebSocket>[];
  final _waiters = <Completer<WebSocket>>[];

  static Future<_FakeHubServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final hub = _FakeHubServer._(server);
    server.listen((request) async {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        final socket = await WebSocketTransformer.upgrade(request);
        hub._offerConnection(socket);
      }
    });
    return hub;
  }

  void _offerConnection(WebSocket socket) {
    if (_waiters.isNotEmpty) {
      _waiters.removeAt(0).complete(socket);
    } else {
      _buffered.add(socket);
    }
  }

  String get url => 'ws://${_server.address.host}:${_server.port}';

  Future<WebSocket> get firstConnection => nextConnection();

  /// Returns the next connection the server accepts — immediately if one
  /// is already buffered, otherwise once one arrives.
  Future<WebSocket> nextConnection() {
    if (_buffered.isNotEmpty) return Future.value(_buffered.removeAt(0));
    final completer = Completer<WebSocket>();
    _waiters.add(completer);
    return completer.future;
  }

  Future<void> close() async {
    await _server.close(force: true);
  }
}

Map<String, dynamic> _decode(dynamic raw) =>
    jsonDecode(raw as String) as Map<String, dynamic>;

void main() {
  late _FakeHubServer hub;
  late SyncWebSocket client;

  setUp(() async {
    hub = await _FakeHubServer.start();
    client = SyncWebSocket(
      logger: Talker(),
      pingInterval: const Duration(minutes: 5), // keep pings out of the way
      maxReconnectDelaySecs: 1, // fast reconnect for the resubscribe test
    );
  });

  tearDown(() async {
    client.dispose();
    await hub.close();
  });

  test('connect transitions connecting -> connected', () async {
    final statuses = <WebSocketConnectionStatus>[];
    client.connectionStatus.listen(statuses.add);

    await client.connect(hub.url, 'test-token');
    await hub.firstConnection;
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(statuses, [
      WebSocketConnectionStatus.connecting,
      WebSocketConnectionStatus.connected,
    ]);
  });

  test('subscribe sends the correct frame and re-sends on reconnect', () async {
    await client.connect(hub.url, 'test-token');
    final serverSocket1 = await hub.firstConnection;

    client.subscribe('orders');
    final firstFrame = _decode(await serverSocket1.first);
    expect(firstFrame, {'type': 'subscribe', 'topic': 'orders'});

    // Simulate the hub dropping the connection; the client should
    // reconnect (maxReconnectDelaySecs: 1) and resubscribe automatically.
    final secondConnection = hub.nextConnection();
    await serverSocket1.close();

    final serverSocket2 = await secondConnection;
    final resubscribeFrame = _decode(await serverSocket2.first);
    expect(resubscribeFrame, {'type': 'subscribe', 'topic': 'orders'});
  });

  test('publish resolves when the hub replies with a matching ack', () async {
    await client.connect(hub.url, 'test-token');
    final serverSocket = await hub.firstConnection;

    serverSocket.listen((raw) {
      final frame = _decode(raw);
      if (frame['type'] == 'publish') {
        serverSocket.add(jsonEncode({'type': 'ack', 'id': frame['id']}));
      }
    });

    await client.publish(
      topic: 'orders',
      event: 'order.created',
      data: {'syncId': 'abc'},
    );
    // Completing without throwing is the assertion.
  });

  test('publish throws SyncPublishException on an error reply', () async {
    await client.connect(hub.url, 'test-token');
    final serverSocket = await hub.firstConnection;

    serverSocket.listen((raw) {
      final frame = _decode(raw);
      if (frame['type'] == 'publish') {
        serverSocket.add(
          jsonEncode({
            'type': 'error',
            'id': frame['id'],
            'message': 'rejected: duplicate syncId',
          }),
        );
      }
    });

    await expectLater(
      client.publish(topic: 'orders', event: 'order.created', data: {}),
      throwsA(
        isA<SyncPublishException>().having(
          (e) => e.message,
          'message',
          'rejected: duplicate syncId',
        ),
      ),
    );
  });

  test('publish throws TimeoutException when no reply arrives', () async {
    await client.connect(hub.url, 'test-token');
    await hub.firstConnection; // hub never replies

    await expectLater(
      client.publish(
        topic: 'orders',
        event: 'order.created',
        data: {},
        timeout: const Duration(milliseconds: 100),
      ),
      throwsA(isA<TimeoutException>()),
    );
  });

  test(
    'disconnecting mid-publish fails the pending publish promptly',
    () async {
      await client.connect(hub.url, 'test-token');
      await hub.firstConnection; // hub never replies

      final publishFuture = client.publish(
        topic: 'orders',
        event: 'order.created',
        data: {},
        timeout: const Duration(seconds: 5),
      );
      // Attach the assertion's listener synchronously, before any await
      // yields control — otherwise disconnect()'s completeError below can
      // race an as-yet-unlistened Future and surface as an unhandled zone
      // error instead of the expected rejection.
      final expectation = expectLater(
        publishFuture,
        throwsA(isA<StateError>()),
      );

      final stopwatch = Stopwatch()..start();
      await client.disconnect();

      await expectation;
      stopwatch.stop();
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(1000),
        reason:
            'disconnect must fail pending publishes immediately, not wait '
            'out the full publish timeout',
      );
    },
  );

  test('inbound message frames surface on .messages', () async {
    await client.connect(hub.url, 'test-token');
    final serverSocket = await hub.firstConnection;

    final messageFuture = client.messages.first;
    serverSocket.add(
      jsonEncode({
        'type': 'message',
        'topic': 'orders',
        'event': 'order.created',
        'data': {'syncId': 'xyz'},
      }),
    );

    final message = await messageFuture;
    expect(message.topic, 'orders');
    expect(message.event, 'order.created');
    expect(message.data, {'syncId': 'xyz'});
  });
}
