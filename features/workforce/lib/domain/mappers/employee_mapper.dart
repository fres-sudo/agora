import 'package:database/database.dart';
import '../models/employee.dart';
import '../models/employee_role.dart';

extension EmployeeEntityMapper on EmployeeEntity {
  // `pin` is intentionally NOT populated here: the entity only ever holds a
  // bcrypt hash (or, transiently, a legacy plaintext value pending
  // upgrade), and list/detail views built on this domain model must never
  // see either. `Employee.pin` is write-only — it carries a new plaintext
  // PIN from the create/edit form down to the mapper that hashes it, and
  // is empty for anything read back out of the database.
  Employee toModel() => Employee(
    id: id,
    name: name,
    pin: '',
    role: EmployeeRole.fromString(role),
    isActive: isActive,
    hourlyRateCents: hourlyRateCents,
    avatarUrl: avatarUrl,
    createdAt: createdAt,
  );
}

extension EmployeeModelMapper on Employee {
  EmployeesTableCompanion toInsertCompanion() => EmployeesTableCompanion.insert(
    name: name,
    pinHash: PinHasher.hash(pin),
    role: Value(role.name),
    isActive: Value(isActive),
    hourlyRateCents: Value(hourlyRateCents),
    avatarUrl: Value(avatarUrl),
  );

  /// Leaves the stored PIN hash untouched when [pin] is empty, i.e. the
  /// operator left the PIN field blank on the edit form to keep the
  /// current PIN.
  EmployeesTableCompanion toUpdateCompanion() => EmployeesTableCompanion(
    name: Value(name),
    pinHash: pin.isEmpty ? const Value.absent() : Value(PinHasher.hash(pin)),
    role: Value(role.name),
    isActive: Value(isActive),
    hourlyRateCents: Value(hourlyRateCents),
    avatarUrl: Value(avatarUrl),
  );
}
