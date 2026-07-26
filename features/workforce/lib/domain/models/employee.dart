import 'package:bloc_exports/bloc_exports.dart';
import 'employee_role.dart';

part 'employee.freezed.dart';

@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    required int id,
    required String name,
    // Write-only: a new plaintext PIN to hash on create/update. Always
    // empty when this model is populated from a stored EmployeeEntity
    // (list/detail views never see the PIN, hashed or otherwise) — see
    // EmployeeEntityMapper.toModel and EmployeeModelMapper.
    required String pin,
    required EmployeeRole role,
    required bool isActive,
    @Default(0) int hourlyRateCents,
    String? avatarUrl,
    DateTime? createdAt,
  }) = _Employee;

  const Employee._();

  bool get isOwner => role == EmployeeRole.owner;
  bool get isManager => role == EmployeeRole.manager || isOwner;
}
