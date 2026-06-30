import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'clock_records_dao.g.dart';

@DriftAccessor(tables: [ClockRecordsTable, EmployeesTable])
class ClockRecordsDao extends DatabaseAccessor<AgoraDatabase>
    with _$ClockRecordsDaoMixin {
  ClockRecordsDao(super.db);

  Stream<List<ClockRecordWithEmployee>> watchClockRecords({int? employeeId}) {
    final query = select(clockRecordsTable).join([
      innerJoin(employeesTable, employeesTable.id.equalsExp(clockRecordsTable.employeeId)),
    ])
      ..where(clockRecordsTable.deletedAt.isNull())
      ..orderBy([OrderingTerm.desc(clockRecordsTable.clockedInAt)]);

    if (employeeId != null) {
      query.where(clockRecordsTable.employeeId.equals(employeeId));
    }

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => ClockRecordWithEmployee(
              record: row.readTable(clockRecordsTable),
              employee: row.readTable(employeesTable),
            ),
          )
          .toList(),
    );
  }

  Future<ClockRecordEntity?> getActiveClockRecord(int employeeId) {
    return (select(clockRecordsTable)
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
    return into(clockRecordsTable).insert(companion);
  }

  Future<bool> updateClockRecord(int id, ClockRecordsTableCompanion companion) {
    return (update(clockRecordsTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}

class ClockRecordWithEmployee {
  const ClockRecordWithEmployee({
    required this.record,
    required this.employee,
  });

  final ClockRecordEntity record;
  final EmployeeEntity employee;
}
