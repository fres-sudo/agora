@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

import 'syncable_repository_test.mocks.dart';

@GenerateMocks([SyncManager])
class _TestRepository extends SyncableRepository {
  _TestRepository({required super.syncManager});

  Future<Result<String>> writeThing({required bool localWriteThrows}) =>
      safeSync<String>(
        operation: 'writeThing',
        entityType: 'thing',
        outboxOperation: OutboxOperation.create,
        entityLocalId: 'thing-1',
        payload: const {'foo': 'bar'},
        localWrite: () async {
          if (localWriteThrows) throw Exception('local write failed');
          return 'written';
        },
      );
}

void main() {
  late MockSyncManager syncManager;
  late _TestRepository repository;

  setUp(() {
    syncManager = MockSyncManager();
    repository = _TestRepository(syncManager: syncManager);
  });

  test('local write succeeds -> enqueues then returns success', () async {
    when(
      syncManager.enqueue(
        entityType: anyNamed('entityType'),
        operation: anyNamed('operation'),
        entityLocalId: anyNamed('entityLocalId'),
        payload: anyNamed('payload'),
        remoteId: anyNamed('remoteId'),
      ),
    ).thenAnswer((_) async {});

    final result = await repository.writeThing(localWriteThrows: false);

    expect(result, isA<Ok<String>>());
    expect((result as Ok<String>).value, 'written');

    final captured = verify(
      syncManager.enqueue(
        entityType: captureAnyNamed('entityType'),
        operation: captureAnyNamed('operation'),
        entityLocalId: captureAnyNamed('entityLocalId'),
        payload: captureAnyNamed('payload'),
        remoteId: anyNamed('remoteId'),
      ),
    ).captured;
    expect(captured, [
      'thing',
      OutboxOperation.create,
      'thing-1',
      {'foo': 'bar'},
    ]);
  });

  test('local write throws -> returns error and never enqueues', () async {
    final result = await repository.writeThing(localWriteThrows: true);

    expect(result, isA<Error<String>>());
    verifyNever(
      syncManager.enqueue(
        entityType: anyNamed('entityType'),
        operation: anyNamed('operation'),
        entityLocalId: anyNamed('entityLocalId'),
        payload: anyNamed('payload'),
        remoteId: anyNamed('remoteId'),
      ),
    );
  });
}
