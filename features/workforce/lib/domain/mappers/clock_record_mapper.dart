import 'package:database/database.dart';
import '../../../data/sources/local/daos/clock_records_dao.dart';
import '../models/clock_record.dart';

extension ClockRecordWithEmployeeMapper on ClockRecordWithEmployee {
  ClockRecord toModel() => ClockRecord(
    id: record.id,
    employeeId: record.employeeId,
    employeeName: employee.name,
    clockedInAt: record.clockedInAt,
    clockedOutAt: record.clockedOutAt,
    note: record.note,
  );
}

extension ClockRecordEntityMapper on ClockRecordEntity {
  ClockRecord toModelWithName(String employeeName) => ClockRecord(
    id: id,
    employeeId: employeeId,
    employeeName: employeeName,
    clockedInAt: clockedInAt,
    clockedOutAt: clockedOutAt,
    note: note,
  );
}

ClockRecordsTableCompanion clockInCompanion(int employeeId) =>
    ClockRecordsTableCompanion.insert(
      employeeId: employeeId,
      clockedInAt: DateTime.now(),
    );

ClockRecordsTableCompanion clockOutCompanion() =>
    ClockRecordsTableCompanion(clockedOutAt: Value(DateTime.now()));
