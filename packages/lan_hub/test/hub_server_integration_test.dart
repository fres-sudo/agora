@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

/// Applies (or rejects) events on a fake `test` topic — proves the whole
/// new wire-protocol addition (pairing, publish/ack/error, broadcast, and
/// that broadcasts include the sender per the loopback hosting design)
/// end to end against a real [HubServer], before any real feature
/// (orders/inventory) is wired through it.
class _FakeApplyHandler implements HubApplyHandler {
  @override
  String get topic => 'test';

  @override
  Future<Map<String, dynamic>> apply({
    required String originDeviceId,
    required String event,
    required Map<String, dynamic> data,
  }) async {
    if (data['reject'] == true) {
      throw Exception('rejected: $data');
    }
    return data;
  }
}

void main() {
  const pin = '1234';

  late HubServer server;
  late int port;

  setUp(() async {
    final pairingTokenService = PairingTokenService(pinProvider: () => pin);
    server = HubServer(
      applyHandlers: {'test': _FakeApplyHandler()},
      pairingTokenService: pairingTokenService,
      logger: Talker(),
    );
    port = await server.start();
  });

  tearDown(() async {
    await server.stop();
  });

  Future<SyncWebSocket> pairAndConnect(String deviceId) async {
    final token = await HubPairingClient(logger: Talker()).pair(
      host: '127.0.0.1',
      port: port,
      pin: pin,
      deviceId: deviceId,
      deviceName: deviceId,
    );
    final socket = SyncWebSocket(logger: Talker());
    await socket.connect('ws://127.0.0.1:$port/sync', token);
    return socket;
  }

  test('pair with the wrong PIN is rejected', () async {
    await expectLater(
      HubPairingClient(logger: Talker()).pair(
        host: '127.0.0.1',
        port: port,
        pin: 'wrong',
        deviceId: 'station-a',
        deviceName: 'Station A',
      ),
      throwsA(isA<HubPairingException>()),
    );
  });

  test('connecting to /sync with an invalid token is forbidden', () async {
    final client = HttpClient();
    addTearDown(() => client.close(force: true));

    final request = await client.getUrl(
      Uri.parse('http://127.0.0.1:$port/sync?token=not-a-real-token'),
    );
    final response = await request.close();
    expect(response.statusCode, HttpStatus.forbidden);
  });

  test('publish -> ack round-trip, and the broadcast reaches every '
      'subscriber including the sender (loopback design)', () async {
    final stationA = await pairAndConnect('station-a');
    final stationB = await pairAndConnect('station-b');
    addTearDown(stationA.dispose);
    addTearDown(stationB.dispose);

    stationA.subscribe('test');
    stationB.subscribe('test');
    // Give the hub a moment to process both subscribe frames before
    // publishing, since subscribe (unlike publish) has no ack.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final stationAMessage = stationA.messages.first;
    final stationBMessage = stationB.messages.first;

    await stationA.publish(
      topic: 'test',
      event: 'thing.created',
      data: {'syncId': 'abc', 'value': 42},
    );

    final messageOnA = await stationAMessage;
    final messageOnB = await stationBMessage;

    for (final message in [messageOnA, messageOnB]) {
      expect(message.topic, 'test');
      expect(message.event, 'thing.created');
      expect(message.data, {'syncId': 'abc', 'value': 42});
    }
  });

  test(
    'publish that the apply handler rejects surfaces as SyncPublishException',
    () async {
      final station = await pairAndConnect('station-a');
      addTearDown(station.dispose);

      await expectLater(
        station.publish(
          topic: 'test',
          event: 'thing.created',
          data: {'reject': true},
        ),
        throwsA(isA<SyncPublishException>()),
      );
    },
  );

  test('connectedStationCount reflects live connections', () async {
    final counts = <int>[];
    final sub = server.connectedStationCount.listen(counts.add);
    addTearDown(sub.cancel);

    final station = await pairAndConnect('station-a');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(counts, contains(1));

    await station.disconnect();
    station.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(counts.last, 0);
  });
}
