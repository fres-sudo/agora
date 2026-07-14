@TestOn('vm')
library;

import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sync_engine/sync_engine.dart';

void main() {
  late AgoraDatabase db;
  late OutboxDao dao;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    dao = OutboxDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insert({
    String entityType = 'order',
    String entityLocalId = 'order-1',
    String status = 'pending',
    int retryCount = 0,
    DateTime? processedAt,
  }) => dao.insertEntry(
    OutboxTableCompanion.insert(
      operationType: 'create',
      entityType: entityType,
      entityLocalId: entityLocalId,
      payload: '{"foo":"bar"}',
      status: Value(status),
      retryCount: Value(retryCount),
      processedAt: processedAt != null
          ? Value(processedAt)
          : const Value.absent(),
    ),
  );

  test(
    'getPendingEntities returns pending and failed-under-cap entries',
    () async {
      await insert(entityLocalId: 'a', status: 'pending');
      await insert(entityLocalId: 'b', status: 'failed', retryCount: 1);
      await insert(entityLocalId: 'c', status: 'inflight');

      final pending = await dao.getPendingEntities();

      expect(pending.map((e) => e.entityLocalId), ['a', 'b']);
    },
  );

  test('getPendingEntities excludes failed entries still within their '
      'RetryBackoff window', () async {
    final now = DateTime(2026, 1, 1, 12);
    await insert(
      entityLocalId: 'still-backing-off',
      status: 'failed',
      retryCount: 2, // 10s backoff (see RetryBackoff)
      processedAt: now,
    );

    final tooSoon = await dao.getPendingEntities(
      now: now.add(const Duration(seconds: 5)),
    );
    expect(tooSoon, isEmpty);

    final afterWindow = await dao.getPendingEntities(
      now: now.add(const Duration(seconds: 10)),
    );
    expect(afterWindow, hasLength(1));
  });

  test('getPendingEntities orders by createdAt ascending', () async {
    await insert(entityLocalId: 'second');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await insert(entityLocalId: 'third');

    // Manually backdate the first row so ordering is deterministic
    // regardless of how fast the two inserts above ran.
    final rows = await db.select(db.outboxTable).get();
    await (db.update(db.outboxTable)
          ..where((t) => t.entityLocalId.equals('second')))
        .write(OutboxTableCompanion(createdAt: Value(DateTime(2020))));
    expect(rows, hasLength(2));

    final pending = await dao.getPendingEntities();
    expect(pending.first.entityLocalId, 'second');
    expect(pending.last.entityLocalId, 'third');
  });

  test(
    'markInflight / markDone transitions — markDone removes the row',
    () async {
      final id = await insert();

      await dao.markInflight(id);
      var rows = await db.select(db.outboxTable).get();
      expect(rows.single.status, 'inflight');

      await dao.markDone(id);
      rows = await db.select(db.outboxTable).get();
      expect(rows, isEmpty);
    },
  );

  test('markFailed increments retryCount and records the reason', () async {
    final id = await insert();

    await dao.markFailed(id, 'boom', 0);

    final row = await (db.select(
      db.outboxTable,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(row.status, 'failed');
    expect(row.failedReason, 'boom');
    expect(row.retryCount, 1);
    expect(row.processedAt, isNotNull);
  });

  test('purgeFailed only removes entries at/over the max retry cap', () async {
    await insert(entityLocalId: 'under-cap', status: 'failed', retryCount: 4);
    await insert(entityLocalId: 'at-cap', status: 'failed', retryCount: 5);
    await insert(entityLocalId: 'over-cap', status: 'failed', retryCount: 6);

    await dao.purgeFailed();

    final remaining = await db.select(db.outboxTable).get();
    expect(remaining.map((e) => e.entityLocalId), ['under-cap']);
  });

  test('toEntry round-trips the JSON payload', () async {
    final id = await insert();
    final row = await (db.select(
      db.outboxTable,
    )..where((t) => t.id.equals(id))).getSingle();

    final entry = OutboxDao.toEntry(row);

    expect(entry.entityType, 'order');
    expect(entry.entityLocalId, 'order-1');
    expect(entry.operation, OutboxOperation.create);
    expect(entry.status, OutboxEntryStatus.pending);
    expect(entry.payload, {'foo': 'bar'});
  });

  test('watchPendingCount reflects only pending/failed rows', () async {
    final counts = <int>[];
    final sub = dao.watchPendingCount().listen(counts.add);
    addTearDown(sub.cancel);

    await insert(status: 'pending');
    await insert(status: 'inflight'); // not counted
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(counts.last, 1);
  });
}
