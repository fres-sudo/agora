// Key-Value store for flexible configuration without schema changes.
// Use this for: Printer IP, Receipt Header, Tax Rate, Currency Symbol.

import 'package:drift/drift.dart';

@DataClassName("AppSettingEntity")
class AppSettingsTable extends Table {
  TextColumn get key => text()(); // e.g., "printer_ip_kitchen"
  TextColumn get value => text()(); // e.g., "192.168.1.50"
  TextColumn get type => text().withDefault(
    const Constant('string'),
  )(); // 'int', 'bool', 'double', 'string', 'json'

  @override
  Set<Column> get primaryKey => {key};
}
