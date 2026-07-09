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

  /// Fetches the active, non-deleted employee with [employeeId] so the
  /// caller can verify a submitted PIN against the stored hash. PIN
  /// comparison cannot happen in SQL since bcrypt hashes are salted
  /// per-row — see PinHasher.verify.
  Future<EmployeeEntity?> getActiveEmployeeForLogin(int employeeId) {
    final table = attachedDatabase.employeesTable;
    return (select(table)..where(
          (t) =>
              t.id.equals(employeeId) &
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

  /// Overwrites the stored PIN hash for [employeeId]. Used to lazily
  /// upgrade a legacy plaintext PIN to a bcrypt hash the first time the
  /// employee successfully logs in.
  Future<void> updatePinHash(int employeeId, String pinHash) {
    final table = attachedDatabase.employeesTable;
    return (update(table)..where((t) => t.id.equals(employeeId))).write(
      EmployeesTableCompanion(pinHash: Value(pinHash)),
    );
  }
}
