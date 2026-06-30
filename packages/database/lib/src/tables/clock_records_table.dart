import 'package:drift/drift.dart';
import '../database_mixin.dart';
import 'employees_table.dart';

@DataClassName("ClockRecordEntity")
class ClockRecordsTable extends Table with TableMixin {
  IntColumn get employeeId => integer().references(EmployeesTable, #id)();
  DateTimeColumn get clockedInAt => dateTime()();
  DateTimeColumn get clockedOutAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
}
