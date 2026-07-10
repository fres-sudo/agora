import 'package:bloc_exports/bloc_exports.dart';

part 'session_employee.freezed.dart';

@freezed
abstract class SessionEmployee with _$SessionEmployee {
  const factory SessionEmployee({
    required int id,
    required String name,
    required String role, // 'owner' | 'manager' | 'cashier'
  }) = _SessionEmployee;

  const SessionEmployee._();

  bool get isOwner => role == 'owner';
  bool get isManager => role == 'manager' || isOwner;
}
