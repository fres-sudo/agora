import 'package:database/database.dart';
import 'package:drift/drift.dart';

class EmployeesDao extends DatabaseAccessor<AgoraDatabase> {
  EmployeesDao(super.db);

  Stream<List<EmployeeEntity>> watchActiveEmployees() {
    final table = attachedDatabase.employeesTable;
    return (select(table)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<List<EmployeeEntity>> getActiveEmployees() {
    final table = attachedDatabase.employeesTable;
    return (select(table)
          ..where((t) => t.deletedAt.isNull() & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Future<EmployeeEntity?> getEmployeeById(int id) {
    final table = attachedDatabase.employeesTable;
    return (select(table)
          ..where((t) => t.id.equals(id) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<int> insertEmployee(EmployeesTableCompanion companion) {
    return into(attachedDatabase.employeesTable).insert(companion);
  }

  Future<bool> updateEmployee(int id, EmployeesTableCompanion companion) {
    final table = attachedDatabase.employeesTable;
    return (update(table)..where((t) => t.id.equals(id)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  Future<bool> softDeleteEmployee(int id) {
    final table = attachedDatabase.employeesTable;
    return (update(table)..where((t) => t.id.equals(id)))
        .write(EmployeesTableCompanion(deletedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }
}
