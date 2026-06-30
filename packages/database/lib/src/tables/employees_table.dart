import 'package:drift/drift.dart';
import '../database_mixin.dart';

@DataClassName("EmployeeEntity")
class EmployeesTable extends Table with TableMixin {
  TextColumn get name => text()();
  TextColumn get pin => text()(); // 4-6 digit PIN, plain text (local-only)
  TextColumn get role => text().withDefault(const Constant('cashier'))(); // owner|manager|cashier
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get hourlyRateCents => integer().withDefault(const Constant(0))();
  TextColumn get avatarUrl => text().nullable()();
}
