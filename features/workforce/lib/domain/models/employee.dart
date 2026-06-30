import 'package:bloc_exports/bloc_exports.dart';
import 'employee_role.dart';

part 'employee.freezed.dart';

@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    required int id,
    required String name,
    required String pin,
    required EmployeeRole role,
    required bool isActive,
    @Default(0) int hourlyRateCents,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _Employee;

  const Employee._();

  String get formattedHourlyRate =>
      '\$${(hourlyRateCents / 100.0).toStringAsFixed(2)}/hr';

  bool get isOwner => role == EmployeeRole.owner;
  bool get isManager => role == EmployeeRole.manager || isOwner;
}
