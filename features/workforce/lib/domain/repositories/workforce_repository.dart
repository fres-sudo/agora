import 'package:result/result.dart';
import '../models/employee.dart';
import '../models/clock_record.dart';
import '../models/cash_reconciliation.dart';

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

  // ── Cash reconciliation ─────────────────────────────────────────────────────

  /// Expected cash for the shift, computed from that shift's completed cash
  /// orders. `0` (not an error) if there were none.
  Future<Result<int>> expectedCashCentsForShift(int clockRecordId);

  Future<Result<CashReconciliation>> recordCashReconciliation({
    required int clockRecordId,
    required int expectedCents,
    required int countedCents,
    String? note,
  });

  Future<Result<int>> getTotalCashVarianceForRange({
    required DateTime startDate,
    required DateTime endDate,
  });
}
