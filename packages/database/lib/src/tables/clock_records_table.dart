import 'package:drift/drift.dart';
import '../database_mixin.dart';
import 'employees_table.dart';

// A given employee may accumulate many *closed* clock records (one per past
// shift), but must have at most one *open* one (clockedOutAt IS NULL) at any
// time. This partial unique index enforces that invariant at the database
// level so a check-then-insert race (e.g. a double-tapped clock-in button,
// or two near-simultaneous submissions) cannot create two overlapping open
// shifts, even if the application-level transaction guard in
// WorkforceRepositoryImpl/ClockRecordsDao is ever bypassed.
@TableIndex.sql(
  'CREATE UNIQUE INDEX idx_clock_records_one_open_shift '
  'ON clock_records_table (employee_id) '
  'WHERE clocked_out_at IS NULL AND deleted_at IS NULL',
)
@DataClassName("ClockRecordEntity")
class ClockRecordsTable extends Table with TableMixin {
  IntColumn get employeeId => integer().references(EmployeesTable, #id)();
  DateTimeColumn get clockedInAt => dateTime()();
  DateTimeColumn get clockedOutAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
}
