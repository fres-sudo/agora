import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'employees_dao.g.dart';

@DriftAccessor(tables: [EmployeesTable])
class EmployeesDao extends DatabaseAccessor<AgoraDatabase>
    with _$EmployeesDaoMixin {
  EmployeesDao(super.db);

  Stream<List<EmployeeEntity>> watchActiveEmployees() {
    return (select(employeesTable)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<EmployeeEntity>> getActiveEmployees() {
    return (select(employeesTable)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<EmployeeEntity?> getEmployeeById(int id) {
    return (select(employeesTable)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<int> insertEmployee(EmployeesTableCompanion companion) {
    return into(employeesTable).insert(companion);
  }

  Future<bool> updateEmployee(int id, EmployeesTableCompanion companion) {
    return (update(employeesTable)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  Future<bool> softDeleteEmployee(int id) {
    return (update(employeesTable)..where((t) => t.id.equals(id)))
        .write(EmployeesTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}
