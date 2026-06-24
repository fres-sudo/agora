import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:talker/talker.dart';

import 'sync_manager_test.mocks.dart';

@GenerateMocks([OutboxQueue, ConnectivityMonitor, SyncWebSocket, SyncHandler])
void main() {
  late MockOutboxQueue mockQueue;
  late MockConnectivityMonitor mockConnectivity;
  late MockSyncWebSocket mockWebSocket;
  late SyncManager manager;

  OutboxEntry makeEntry({required int id, required String entityType}) {
    return OutboxEntry(
      id: id,
      operation: OutboxOperation.create,
      entityType: entityType,
      entityLocalId: id.toString(),
      payload: const {'key': 'value'},
      status: OutboxEntryStatus.pending,
      retryCount: 0,
      createdAt: DateTime(2025),
    );
  }

  setUp(() {
    mockQueue = MockOutboxQueue();
    mockConnectivity = MockConnectivityMonitor();
    mockWebSocket = MockSyncWebSocket();

    // Safe defaults for every test.
    when(mockConnectivity.currentStatus).thenAnswer((_) async => true);
    when(mockConnectivity.isOnline).thenAnswer((_) => Stream<bool>.empty());
    when(mockQueue.pendingEntries()).thenAnswer((_) async => []);
    when(mockWebSocket.messages).thenAnswer((_) => Stream<SyncMessage>.empty());
    when(mockWebSocket.disconnect()).thenAnswer((_) async {});

    manager = SyncManager(
      outboxQueue: mockQueue,
      connectivity: mockConnectivity,
      webSocket: mockWebSocket,
      logger: Talker(),
    );
  });

  tearDown(() async {
    await manager.stop();
  });

  // ------------------------------------------------------------------ start

  group('start()', () {
    test('emits SyncIdle when online with empty outbox', () async {
      final statuses = <SyncStatus>[];
      manager.status.listen(statuses.add);

      await manager.start();
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(isA<SyncIdle>()));
    });

    test('emits SyncPaused when offline — does not drain', () async {
      when(mockConnectivity.currentStatus).thenAnswer((_) async => false);

      final statuses = <SyncStatus>[];
      manager.status.listen(statuses.add);

      await manager.start();

      expect(statuses.last, isA<SyncPaused>());
      verifyNever(mockQueue.pendingEntries());
    });

    test('connects WebSocket when url and token supplied and online', () async {
      when(mockWebSocket.connect(any, any)).thenAnswer((_) async {});

      await manager.start(
        webSocketUrl: 'wss://api.agora.io/ws',
        authToken: 'jwt-token',
      );

      verify(
        mockWebSocket.connect('wss://api.agora.io/ws', 'jwt-token'),
      ).called(1);
    });

    test('skips WebSocket connection when offline', () async {
      when(mockConnectivity.currentStatus).thenAnswer((_) async => false);

      await manager.start(
        webSocketUrl: 'wss://api.agora.io/ws',
        authToken: 'jwt-token',
      );

      verifyNever(mockWebSocket.connect(any, any));
    });
  });

  // ------------------------------------------------------------------ drain

  group('drain — handler dispatch', () {
    test('calls handler and marks entry done on success', () async {
      final entry = makeEntry(id: 1, entityType: 'order');

      var pendingCallCount1 = 0;
      when(mockQueue.pendingEntries()).thenAnswer((_) async => pendingCallCount1++ == 0 ? [entry] : []);
      when(mockQueue.markInflight(1)).thenAnswer((_) async {});
      when(mockQueue.markDone(1)).thenAnswer((_) async {});

      final handler = MockSyncHandler();
      when(handler.entityType).thenReturn('order');
      when(handler.handle(entry)).thenAnswer((_) async {});

      manager.registerHandler(handler);
      await manager.start();
      await Future<void>.delayed(Duration.zero);

      verify(handler.handle(entry)).called(1);
      verify(mockQueue.markDone(1)).called(1);
      verifyNever(mockQueue.markFailed(any, any, any));
    });

    test('marks entry failed when handler throws', () async {
      final entry = makeEntry(id: 2, entityType: 'order');

      when(mockQueue.pendingEntries()).thenAnswer((_) async => [entry]);
      when(mockQueue.markInflight(2)).thenAnswer((_) async {});
      when(mockQueue.markFailed(any, any, any)).thenAnswer((_) async {});

      final handler = MockSyncHandler();
      when(handler.entityType).thenReturn('order');
      when(handler.handle(entry)).thenThrow(Exception('network timeout'));

      manager.registerHandler(handler);
      await manager.start();
      await Future<void>.delayed(Duration.zero);

      verify(mockQueue.markFailed(2, any, 0)).called(1);
      verifyNever(mockQueue.markDone(any));
    });

    test('marks entry failed when no handler registered', () async {
      final entry = makeEntry(id: 3, entityType: 'unknown_entity');

      var pendingCallCount3 = 0;
      when(mockQueue.pendingEntries()).thenAnswer((_) async => pendingCallCount3++ == 0 ? [entry] : []);
      when(mockQueue.markFailed(any, any, any)).thenAnswer((_) async {});

      await manager.start();
      await Future<void>.delayed(Duration.zero);

      verify(mockQueue.markFailed(3, any, 0)).called(1);
    });

    test('emits SyncInProgress then SyncIdle during drain', () async {
      final entry = makeEntry(id: 4, entityType: 'order');
      final statuses = <SyncStatus>[];

      var pendingCallCount4 = 0;
      when(mockQueue.pendingEntries()).thenAnswer((_) async => pendingCallCount4++ == 0 ? [entry] : []);
      when(mockQueue.markInflight(4)).thenAnswer((_) async {});
      when(mockQueue.markDone(4)).thenAnswer((_) async {});

      final handler = MockSyncHandler();
      when(handler.entityType).thenReturn('order');
      when(handler.handle(entry)).thenAnswer((_) async {});

      manager
        ..registerHandler(handler)
        ..status.listen(statuses.add);

      await manager.start();
      await Future<void>.delayed(Duration.zero);

      expect(
        statuses,
        containsAllInOrder([isA<SyncInProgress>(), isA<SyncIdle>()]),
      );
    });

    test('emits SyncFailed when entry exceeds max retries', () async {
      final exhaustedEntry = OutboxEntry(
        id: 5,
        operation: OutboxOperation.create,
        entityType: 'order',
        entityLocalId: '5',
        payload: const {},
        status: OutboxEntryStatus.failed,
        retryCount: 4, // one away from max (5)
        createdAt: DateTime(2025),
      );

      when(mockQueue.pendingEntries()).thenAnswer((_) async => [exhaustedEntry]);
      when(mockQueue.markInflight(5)).thenAnswer((_) async {});
      when(mockQueue.markFailed(any, any, any)).thenAnswer((_) async {});

      final handler = MockSyncHandler();
      when(handler.entityType).thenReturn('order');
      when(handler.handle(exhaustedEntry)).thenThrow(Exception('fail'));

      final statuses = <SyncStatus>[];
      manager
        ..registerHandler(handler)
        ..status.listen(statuses.add);

      await manager.start();
      await Future<void>.delayed(Duration.zero);

      expect(statuses, contains(isA<SyncFailed>()));
    });
  });

  // ------------------------------------------------------------------ enqueue

  group('enqueue()', () {
    test('delegates to OutboxQueue and triggers drain', () async {
      when(
        mockQueue.enqueue(
          entityType: anyNamed('entityType'),
          operation: anyNamed('operation'),
          entityLocalId: anyNamed('entityLocalId'),
          payload: anyNamed('payload'),
          remoteId: anyNamed('remoteId'),
        ),
      ).thenAnswer((_) async {});

      await manager.start();
      await manager.enqueue(
        entityType: 'order',
        operation: OutboxOperation.create,
        entityLocalId: '99',
        payload: {'status': 0},
      );

      verify(
        mockQueue.enqueue(
          entityType: 'order',
          operation: OutboxOperation.create,
          entityLocalId: '99',
          payload: {'status': 0},
          remoteId: null,
        ),
      ).called(1);
    });
  });

  // ------------------------------------------------------------------ connectivity

  group('connectivity changes', () {
    test(
      'emits SyncPaused and disconnects WebSocket when going offline',
      () async {
        final onlineController = StreamController<bool>();
        when(
          mockConnectivity.isOnline,
        ).thenAnswer((_) => onlineController.stream);

        final statuses = <SyncStatus>[];
        manager.status.listen(statuses.add);

        await manager.start();
        onlineController.add(false);
        await Future<void>.delayed(Duration.zero);

        expect(statuses, contains(isA<SyncPaused>()));
        verify(mockWebSocket.disconnect()).called(greaterThanOrEqualTo(1));

        await onlineController.close();
      },
    );

    test('resumes drain when coming back online after offline start', () async {
      when(mockConnectivity.currentStatus).thenAnswer((_) async => false);

      final onlineController = StreamController<bool>();
      when(
        mockConnectivity.isOnline,
      ).thenAnswer((_) => onlineController.stream);

      await manager.start();
      verifyNever(mockQueue.pendingEntries());

      onlineController.add(true);
      await Future<void>.delayed(Duration.zero);

      verify(mockQueue.pendingEntries()).called(greaterThanOrEqualTo(1));

      await onlineController.close();
    });
  });
}
