import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'auth_dao.g.dart';

@DriftAccessor(tables: [EmployeesTable])
class AuthDao extends DatabaseAccessor<AgoraDatabase> with _$AuthDaoMixin {
  AuthDao(super.db);

  Future<List<EmployeeEntity>> getActiveEmployees() {
    return (select(employeesTable)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<EmployeeEntity?> getEmployeeByPin(int employeeId, String pin) {
    return (select(employeesTable)
          ..where(
            (t) =>
                t.id.equals(employeeId) &
                t.pin.equals(pin) &
                t.isActive.equals(true) &
                t.deletedAt.isNull(),
          ))
        .getSingleOrNull();
  }

  Future<EmployeeEntity?> getEmployeeById(int id) {
    return (select(employeesTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }
}
