import 'package:feature_workforce/domain/models/employee.dart';
import 'package:feature_workforce/domain/models/employee_role.dart';
import 'package:feature_workforce/presentation/blocs/employees/employees_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plaintext PIN is redacted from employee and Bloc event strings', () {
    const employee = Employee(
      id: 0,
      name: 'Ada',
      pin: '1234',
      role: EmployeeRole.cashier,
      isActive: true,
    );
    const event = EmployeesEvent.created(employee);

    expect(employee.toString(), isNot(contains('1234')));
    expect(event.toString(), isNot(contains('1234')));
  });
}
