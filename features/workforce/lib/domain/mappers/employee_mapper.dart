import 'package:database/database.dart';
import '../models/employee.dart';
import '../models/employee_role.dart';

extension EmployeeEntityMapper on EmployeeEntity {
  Employee toModel() => Employee(
    id: id,
    name: name,
    pin: pin,
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
    pin: pin,
    role: Value(role.name),
    isActive: Value(isActive),
    hourlyRateCents: Value(hourlyRateCents),
    avatarUrl: Value(avatarUrl),
  );

  EmployeesTableCompanion toUpdateCompanion() => EmployeesTableCompanion(
    name: Value(name),
    pin: Value(pin),
    role: Value(role.name),
    isActive: Value(isActive),
    hourlyRateCents: Value(hourlyRateCents),
    avatarUrl: Value(avatarUrl),
  );
}
