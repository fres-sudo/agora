import 'package:drift/drift.dart';
import '../database_mixin.dart';

@DataClassName("EmployeeEntity")
class EmployeesTable extends Table with TableMixin {
  TextColumn get name => text()();
  // Bcrypt hash of the employee's 4-6 digit PIN — never plaintext. The
  // column keeps its original SQL name ("pin") so no schema migration is
  // needed; only the Dart-facing getter is renamed. See PinHasher.
  TextColumn get pinHash => text().named('pin')();
  TextColumn get role =>
      text().withDefault(const Constant('cashier'))(); // owner|manager|cashier
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get hourlyRateCents => integer().withDefault(const Constant(0))();
  TextColumn get avatarUrl => text().nullable()();
}
