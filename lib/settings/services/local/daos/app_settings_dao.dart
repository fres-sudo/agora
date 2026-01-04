import 'package:agora/core/database/database.dart';
import 'package:agora/settings/services/local/tables/settings_table.dart';
import 'package:drift/drift.dart';

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [AppSettingsTable])
class AppSettingsDao extends DatabaseAccessor<AgoraDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  // Common setting keys
  static const String keyPrinterIpKitchen = 'printer_ip_kitchen';
  static const String keyPrinterIpReceipt = 'printer_ip_receipt';
  static const String keyReceiptHeader = 'receipt_header';
  static const String keyReceiptFooter = 'receipt_footer';
  static const String keyTaxRate = 'tax_rate';
  static const String keyCurrencySymbol = 'currency_symbol';
  static const String keyBusinessName = 'business_name';
  static const String keyBusinessAddress = 'business_address';

  // Setting types
  static const String typeString = 'string';
  static const String typeInt = 'int';
  static const String typeBool = 'bool';
  static const String typeJson = 'json';

  // ============================================================
  // READ OPERATIONS (Streams for CQRS pattern)
  // ============================================================

  /// Watches all settings.
  Stream<List<AppSettingEntity>> watchAllSettings() {
    return (select(
      appSettingsTable,
    )..orderBy([(t) => OrderingTerm.asc(t.key)])).watch();
  }

  /// Watches a single setting by key.
  Stream<AppSettingEntity?> watchSettingByKey(String key) {
    return (select(
      appSettingsTable,
    )..where((t) => t.key.equals(key))).watchSingleOrNull();
  }

  /// Gets a single setting by key (Future-based).
  Future<AppSettingEntity?> getSettingByKey(String key) {
    return (select(
      appSettingsTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
  }

  /// Gets the value of a setting by key.
  Future<String?> getSettingValue(String key) async {
    final setting = await getSettingByKey(key);
    return setting?.value;
  }

  /// Gets settings by key prefix (e.g., 'printer_*').
  Future<List<AppSettingEntity>> getSettingsByPrefix(String prefix) {
    return (select(appSettingsTable)
          ..where((t) => t.key.like('$prefix%'))
          ..orderBy([(t) => OrderingTerm.asc(t.key)]))
        .get();
  }

  /// Watches settings by key prefix.
  Stream<List<AppSettingEntity>> watchSettingsByPrefix(String prefix) {
    return (select(appSettingsTable)
          ..where((t) => t.key.like('$prefix%'))
          ..orderBy([(t) => OrderingTerm.asc(t.key)]))
        .watch();
  }

  /// Gets all printer-related settings.
  Future<List<AppSettingEntity>> getPrinterSettings() {
    return getSettingsByPrefix('printer_');
  }

  /// Gets all receipt-related settings.
  Future<List<AppSettingEntity>> getReceiptSettings() {
    return getSettingsByPrefix('receipt_');
  }

  /// Gets the total count of settings.
  Future<int> getSettingsCount() async {
    final count = appSettingsTable.key.count();
    final query = selectOnly(appSettingsTable)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ============================================================
  // TYPED GETTERS (Convenience methods)
  // ============================================================

  /// Gets a setting value as a string.
  Future<String?> getString(String key) async {
    return getSettingValue(key);
  }

  /// Gets a setting value as an integer.
  Future<int?> getInt(String key) async {
    final value = await getSettingValue(key);
    return value != null ? int.tryParse(value) : null;
  }

  /// Gets a setting value as a boolean.
  Future<bool?> getBool(String key) async {
    final value = await getSettingValue(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Gets a setting value as a double.
  Future<double?> getDouble(String key) async {
    final value = await getSettingValue(key);
    return value != null ? double.tryParse(value) : null;
  }

  // ============================================================
  // WRITE OPERATIONS
  // ============================================================

  /// Inserts a new setting.
  Future<int> insertSetting(AppSettingsTableCompanion companion) {
    return into(appSettingsTable).insert(companion);
  }

  /// Updates an existing setting by key.
  Future<bool> updateSetting(String key, AppSettingsTableCompanion companion) {
    return (update(appSettingsTable)..where((t) => t.key.equals(key)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())))
        .then((rows) => rows > 0);
  }

  /// Creates or updates a setting (upsert).
  Future<void> upsertSetting({
    required String key,
    required String value,
    String type = typeString,
  }) async {
    final existing = await getSettingByKey(key);
    if (existing != null) {
      await updateSetting(
        key,
        AppSettingsTableCompanion(value: Value(value), type: Value(type)),
      );
    } else {
      await insertSetting(
        AppSettingsTableCompanion.insert(
          id: 0, // FIXME: This is a temporary solution
          key: key,
          value: value,
          type: Value(type),
        ),
      );
    }
  }

  /// Sets a string setting.
  Future<void> setString(String key, String value) {
    return upsertSetting(key: key, value: value, type: typeString);
  }

  /// Sets an integer setting.
  Future<void> setInt(String key, int value) {
    return upsertSetting(key: key, value: value.toString(), type: typeInt);
  }

  /// Sets a boolean setting.
  Future<void> setBool(String key, bool value) {
    return upsertSetting(key: key, value: value.toString(), type: typeBool);
  }

  /// Sets a double setting.
  Future<void> setDouble(String key, double value) {
    return upsertSetting(key: key, value: value.toString(), type: typeString);
  }

  // ============================================================
  // DELETE OPERATIONS
  // ============================================================

  /// Deletes a setting by key.
  Future<int> deleteSetting(String key) {
    return (delete(appSettingsTable)..where((t) => t.key.equals(key))).go();
  }

  /// Deletes all settings matching a prefix.
  Future<int> deleteSettingsByPrefix(String prefix) {
    return (delete(
      appSettingsTable,
    )..where((t) => t.key.like('$prefix%'))).go();
  }

  /// Deletes all settings (use with caution).
  Future<int> deleteAllSettings() {
    return delete(appSettingsTable).go();
  }
}
