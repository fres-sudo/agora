// Key-Value store for flexible configuration without schema changes.
// Use this for: Printer IP, Receipt Header, Tax Rate, Currency Symbol.
import 'package:agora/core/mixins/database_mixin.dart';
import 'package:drift/drift.dart';

@DataClassName("AppSettingEntity")
class AppSettingsTable extends Table with TableMixin {
  TextColumn get key => text().unique()(); // e.g., "printer_ip_kitchen"
  TextColumn get value => text()(); // e.g., "192.168.1.50"
  TextColumn get type => text().withDefault(
    const Constant('string'),
  )(); // 'int', 'bool', 'string', 'json'

  @override
  Set<Column> get primaryKey => {key};
}
