import 'dart:convert';

import 'package:database/database.dart';
import 'package:drift/drift.dart';

import '../model/outbox_entry.dart';
import 'retry_backoff.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [OutboxTable])
class OutboxDao extends DatabaseAccessor<AgoraDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  static const _maxRetries = 5;

  // ------------------------------------------------------------------ read

  /// Reactive count of entries still needing to be synced.
  Stream<int> watchPendingCount() {
    final count = outboxTable.id.count();
    return (selectOnly(outboxTable)
          ..addColumns([count])
          ..where(outboxTable.status.isIn(['pending', 'failed'])))
        .watch()
        .map((rows) => rows.first.read(count) ?? 0);
  }

  /// Returns pending + failed entries (below retry cap) ordered by creation
  /// time, excluding failed entries still within their exponential backoff
  /// window (see [RetryBackoff]).
  ///
  /// [now] is exposed for testability; callers normally leave it unset.
  Future<List<OutboxEntity>> getPendingEntities({DateTime? now}) async {
    final rows =
        await (select(outboxTable)
              ..where(
                (t) =>
                    t.status.isIn(['pending', 'failed']) &
                    t.retryCount.isSmallerThanValue(_maxRetries),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    return rows
        .where(
          (row) => RetryBackoff.isReady(
            retryCount: row.retryCount,
            lastAttemptAt: row.processedAt,
            now: now,
          ),
        )
        .toList();
  }

  // ------------------------------------------------------------------ write

  Future<int> insertEntry(OutboxTableCompanion companion) =>
      into(outboxTable).insert(companion);

  Future<void> markInflight(int id) =>
      (update(outboxTable)..where((t) => t.id.equals(id))).write(
        const OutboxTableCompanion(status: Value('inflight')),
      );

  /// Successful sync — remove the entry entirely.
  Future<void> markDone(int id) =>
      (delete(outboxTable)..where((t) => t.id.equals(id))).go();

  Future<void> markFailed(int id, String reason, int currentRetryCount) =>
      (update(outboxTable)..where((t) => t.id.equals(id))).write(
        OutboxTableCompanion(
          status: const Value('failed'),
          failedReason: Value(reason),
          retryCount: Value(currentRetryCount + 1),
          processedAt: Value(DateTime.now()),
        ),
      );

  /// Clears permanently failed entries (retryCount >= max).
  Future<void> purgeFailed() =>
      (delete(outboxTable)..where(
            (t) =>
                t.status.equals('failed') &
                t.retryCount.isBiggerOrEqualValue(_maxRetries),
          ))
          .go();

  // ------------------------------------------------------------------ mapper

  static OutboxEntry toEntry(OutboxEntity entity) => OutboxEntry(
    id: entity.id,
    operation: OutboxOperation.fromString(entity.operationType),
    entityType: entity.entityType,
    entityLocalId: entity.entityLocalId,
    remoteId: entity.remoteId,
    payload: jsonDecode(entity.payload) as Map<String, dynamic>,
    status: OutboxEntryStatus.fromString(entity.status),
    retryCount: entity.retryCount,
    failedReason: entity.failedReason,
    createdAt: entity.createdAt,
    processedAt: entity.processedAt,
  );
}
