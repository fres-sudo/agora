part of 'employees_bloc.dart';

@freezed
abstract class EmployeesEvent with _$EmployeesEvent {
  const factory EmployeesEvent.started() = _Started;
  const factory EmployeesEvent.created(Employee employee) = _Created;
  const factory EmployeesEvent.updated(Employee employee) = _Updated;
  const factory EmployeesEvent.deleted(int id) = _Deleted;
}
