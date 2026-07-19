import 'package:database/database.dart';
import 'package:drift/drift.dart';

class CashReconciliationsDao extends DatabaseAccessor<AgoraDatabase> {
  CashReconciliationsDao(super.db);

  Future<CashReconciliationEntity?> getByClockRecordId(int clockRecordId) {
    final table = attachedDatabase.cashReconciliationsTable;
    return (select(
      table,
    )..where((t) => t.clockRecordId.equals(clockRecordId))).getSingleOrNull();
  }

  Future<int> insertReconciliation(
    CashReconciliationsTableCompanion companion,
  ) {
    return into(attachedDatabase.cashReconciliationsTable).insert(companion);
  }

  /// Sum of varianceCents across reconciliations closed within
  /// [startDate, endDate] — backs the EndOfDaySummary rollup tile.
  Future<int> getTotalVariance({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final table = attachedDatabase.cashReconciliationsTable;
    final sum = table.varianceCents.sum();
    final query = selectOnly(table)
      ..addColumns([sum])
      ..where(
        table.deletedAt.isNull() &
            table.createdAt.isBiggerOrEqualValue(startDate) &
            table.createdAt.isSmallerOrEqualValue(endDate),
      );
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }
}
