import 'package:database/database.dart';
import 'package:drift/drift.dart';

class AuthDao extends DatabaseAccessor<AgoraDatabase> {
  AuthDao(super.db);

  Future<List<EmployeeEntity>> getActiveEmployees() {
    final table = attachedDatabase.employeesTable;
    return (select(table)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<EmployeeEntity?> getEmployeeByPin(int employeeId, String pin) {
    final table = attachedDatabase.employeesTable;
    return (select(table)..where(
          (t) =>
              t.id.equals(employeeId) &
              t.pin.equals(pin) &
              t.isActive.equals(true) &
              t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<EmployeeEntity?> getEmployeeById(int id) {
    final table = attachedDatabase.employeesTable;
    return (select(
      table,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
  }
}
