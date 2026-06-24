import 'dart:convert';

import 'package:database/database.dart';
import 'package:drift/drift.dart';

import '../model/outbox_entry.dart';
import 'outbox_dao.dart';

class OutboxQueue {
  OutboxQueue({required OutboxDao dao}) : _dao = dao;

  final OutboxDao _dao;

  /// Live count of entries still to be processed.
  Stream<int> get pendingCount => _dao.watchPendingCount();

  Future<void> enqueue({
    required String entityType,
    required OutboxOperation operation,
    required String entityLocalId,
    required Map<String, dynamic> payload,
    String? remoteId,
  }) async {
    await _dao.insertEntry(
      OutboxTableCompanion.insert(
        operationType: operation.name,
        entityType: entityType,
        entityLocalId: entityLocalId,
        payload: jsonEncode(payload),
        remoteId: Value(remoteId),
      ),
    );
  }

  Future<List<OutboxEntry>> pendingEntries() async {
    final entities = await _dao.getPendingEntities();
    return entities.map(OutboxDao.toEntry).toList();
  }

  Future<void> markInflight(int id) => _dao.markInflight(id);

  Future<void> markDone(int id) => _dao.markDone(id);

  Future<void> markFailed(int id, String reason, int currentRetryCount) =>
      _dao.markFailed(id, reason, currentRetryCount);

  Future<void> purgeFailed() => _dao.purgeFailed();
}
