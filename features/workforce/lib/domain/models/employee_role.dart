enum EmployeeRole {
  owner,
  manager,
  cashier;

  static EmployeeRole fromString(String value) => EmployeeRole.values
      .firstWhere((e) => e.name == value, orElse: () => EmployeeRole.cashier);

  String get label => switch (this) {
    EmployeeRole.owner => 'Owner',
    EmployeeRole.manager => 'Manager',
    EmployeeRole.cashier => 'Cashier',
  };
}
