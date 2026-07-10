import 'package:database/database.dart';
import 'package:drift/drift.dart';

class ClockRecordsDao extends DatabaseAccessor<AgoraDatabase> {
  ClockRecordsDao(super.db);

  Stream<List<ClockRecordWithEmployee>> watchClockRecords({int? employeeId}) {
    final clockTable = attachedDatabase.clockRecordsTable;
    final employeesTable = attachedDatabase.employeesTable;
    final query =
        select(clockTable).join([
            innerJoin(
              employeesTable,
              employeesTable.id.equalsExp(clockTable.employeeId),
            ),
          ])
          ..where(clockTable.deletedAt.isNull())
          ..orderBy([OrderingTerm.desc(clockTable.clockedInAt)]);

    if (employeeId != null) {
      query.where(clockTable.employeeId.equals(employeeId));
    }

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => ClockRecordWithEmployee(
              record: row.readTable(clockTable),
              employee: row.readTable(employeesTable),
            ),
          )
          .toList(),
    );
  }

  Future<ClockRecordEntity?> getActiveClockRecord(int employeeId) {
    final table = attachedDatabase.clockRecordsTable;
    return (select(table)
          ..where(
            (t) =>
                t.employeeId.equals(employeeId) &
                t.clockedOutAt.isNull() &
                t.deletedAt.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertClockRecord(ClockRecordsTableCompanion companion) {
    return into(attachedDatabase.clockRecordsTable).insert(companion);
  }

  /// Atomically checks for an existing open shift and inserts [companion] as
  /// a new clock-in only if none is found, returning the new record's id.
  ///
  /// Returns `null` (and inserts nothing) if [employeeId] already has an
  /// open shift. Wrapping the check and the insert in a single Drift
  /// transaction closes the check-then-insert race that a bare
  /// `getActiveClockRecord` + `insertClockRecord` pair would allow between
  /// two near-simultaneous clock-in calls for the same employee. A partial
  /// unique index on the table (`idx_clock_records_one_open_shift`) backs
  /// this up at the database level in case this invariant is ever bypassed.
  Future<int?> tryClockIn(
    int employeeId,
    ClockRecordsTableCompanion companion,
  ) {
    return attachedDatabase.transaction(() async {
      final active = await getActiveClockRecord(employeeId);
      if (active != null) return null;
      return insertClockRecord(companion);
    });
  }

  Future<bool> updateClockRecord(int id, ClockRecordsTableCompanion companion) {
    final table = attachedDatabase.clockRecordsTable;
    return (update(table)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}

class ClockRecordWithEmployee {
  const ClockRecordWithEmployee({required this.record, required this.employee});

  final ClockRecordEntity record;
  final EmployeeEntity employee;
}
