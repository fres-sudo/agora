import 'package:errors/errors.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';
import '../sources/local/daos/employees_dao.dart';
import '../sources/local/daos/clock_records_dao.dart';
import '../../domain/mappers/employee_mapper.dart';
import '../../domain/mappers/clock_record_mapper.dart';
import '../../domain/models/employee.dart';
import '../../domain/models/clock_record.dart';
import '../../domain/repositories/workforce_repository.dart';

class WorkforceRepositoryImpl extends Repository
    implements WorkforceRepository {
  WorkforceRepositoryImpl({
    required EmployeesDao employeesDao,
    required ClockRecordsDao clockRecordsDao,
    Talker? logger,
  }) : _employeesDao = employeesDao,
       _clockRecordsDao = clockRecordsDao,
       super(logger);

  final EmployeesDao _employeesDao;
  final ClockRecordsDao _clockRecordsDao;

  // ── Employees ──────────────────────────────────────────────────────────────

  @override
  Stream<List<Employee>> watchActiveEmployees() => _employeesDao
      .watchActiveEmployees()
      .map((entities) => entities.map((e) => e.toModel()).toList())
      .safeCode(logger);

  @override
  Future<Result<List<Employee>>> getActiveEmployees() =>
      safe('getActiveEmployees', () async {
        final entities = await _employeesDao.getActiveEmployees();
        return entities.map((e) => e.toModel()).toList();
      });

  @override
  Future<Result<Employee>> createEmployee(Employee employee) =>
      safe('createEmployee(${employee.name})', () async {
        final id = await _employeesDao.insertEmployee(
          employee.toInsertCompanion(),
        );
        return employee.copyWith(id: id);
      });

  @override
  Future<Result<Employee>> updateEmployee(Employee employee) =>
      safe('updateEmployee(${employee.id})', () async {
        await _employeesDao.updateEmployee(
          employee.id,
          employee.toUpdateCompanion(),
        );
        return employee;
      });

  @override
  Future<Result<int>> deleteEmployee(int id) =>
      safe('deleteEmployee($id)', () async {
        await _employeesDao.softDeleteEmployee(id);
        return id;
      });

  // ── Clock records ──────────────────────────────────────────────────────────

  @override
  Stream<List<ClockRecord>> watchClockRecords({int? employeeId}) =>
      _clockRecordsDao
          .watchClockRecords(employeeId: employeeId)
          .map((rows) => rows.map((r) => r.toModel()).toList())
          .safeCode(logger);

  @override
  Future<Result<ClockRecord?>> getActiveClockRecord(int employeeId) =>
      safe('getActiveClockRecord($employeeId)', () async {
        final entity = await _clockRecordsDao.getActiveClockRecord(employeeId);
        if (entity == null) return null;
        final emp = await _employeesDao.getEmployeeById(employeeId);
        return entity.toModelWithName(emp?.name ?? '');
      });

  @override
  Future<Result<ClockRecord>> clockIn(int employeeId) =>
      safe('clockIn($employeeId)', () async {
        // The check-for-open-shift and the insert happen atomically inside
        // a single Drift transaction (see ClockRecordsDao.tryClockIn), so
        // two near-simultaneous clockIn calls for the same employee cannot
        // both succeed. A partial unique index on the table enforces the
        // same invariant at the database level as a second line of defense.
        final id = await _clockRecordsDao.tryClockIn(
          employeeId,
          clockInCompanion(employeeId),
        );
        if (id == null) {
          throw RepositoryException('Employee is already clocked in');
        }
        final emp = await _employeesDao.getEmployeeById(employeeId);
        return ClockRecord(
          id: id,
          employeeId: employeeId,
          employeeName: emp?.name ?? '',
          clockedInAt: DateTime.now(),
        );
      });

  @override
  Future<Result<ClockRecord>> clockOut(int employeeId) => safe(
    'clockOut($employeeId)',
    () async {
      final active = await _clockRecordsDao.getActiveClockRecord(employeeId);
      if (active == null) {
        throw RepositoryException('No active clock-in found');
      }
      await _clockRecordsDao.updateClockRecord(active.id, clockOutCompanion());
      final emp = await _employeesDao.getEmployeeById(employeeId);
      return active
          .toModelWithName(emp?.name ?? '')
          .copyWith(clockedOutAt: DateTime.now());
    },
  );
}
