import 'package:result/result.dart';
import '../models/employee.dart';
import '../models/clock_record.dart';

abstract interface class WorkforceRepository {
  // ── Employees ──────────────────────────────────────────────────────────────

  Stream<List<Employee>> watchActiveEmployees();

  Future<Result<List<Employee>>> getActiveEmployees();

  Future<Result<Employee>> createEmployee(Employee employee);

  Future<Result<Employee>> updateEmployee(Employee employee);

  Future<Result<int>> deleteEmployee(int id);

  // ── Clock records ──────────────────────────────────────────────────────────

  Stream<List<ClockRecord>> watchClockRecords({int? employeeId});

  Future<Result<ClockRecord?>> getActiveClockRecord(int employeeId);

  Future<Result<ClockRecord>> clockIn(int employeeId);

  Future<Result<ClockRecord>> clockOut(int employeeId);
}
