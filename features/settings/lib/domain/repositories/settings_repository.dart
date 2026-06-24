import 'package:database/database.dart';
import 'package:result/result.dart';
import 'package:result/result.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:talker/talker.dart';

/// An app setting record.
typedef AppSetting = ({String key, String value, String type});

/// Repository interface for app settings operations.
///
/// All write operations return the affected setting for optimistic updates.
abstract interface class SettingsRepository {
  // ============================================================
  // STREAMS - For reactive UI binding
  // ============================================================

  /// Watches all settings.
  Stream<List<AppSetting>> watchAllSettings();

  /// Watches a single setting by key.
  Stream<String?> watchSettingValue(String key);

  /// Watches settings by key prefix (e.g., 'printer_').
  Stream<List<AppSetting>> watchSettingsByPrefix(String prefix);

  // ============================================================
  // READ OPERATIONS - Future-based with Result
  // ============================================================

  /// Gets a setting value as a string.
  Future<Result<String?>> getString(String key);

  /// Gets a setting value as an integer.
  Future<Result<int?>> getInt(String key);

  /// Gets a setting value as a boolean.
  Future<Result<bool?>> getBool(String key);

  /// Gets a setting value as a double.
  Future<Result<double?>> getDouble(String key);

  /// Gets all printer-related settings.
  Future<Result<List<AppSetting>>> getPrinterSettings();

  /// Gets all receipt-related settings.
  Future<Result<List<AppSetting>>> getReceiptSettings();

  // ============================================================
  // WRITE OPERATIONS - Returns setting for optimistic updates
  // ============================================================

  /// Sets a string setting.
  /// Returns the [AppSetting] for optimistic updates.
  Future<Result<AppSetting>> setString(String key, String value);

  /// Sets an integer setting.
  /// Returns the [AppSetting] for optimistic updates.
  Future<Result<AppSetting>> setInt(String key, int value);

  /// Sets a boolean setting.
  /// Returns the [AppSetting] for optimistic updates.
  Future<Result<AppSetting>> setBool(String key, bool value);

  /// Sets a double setting.
  /// Returns the [AppSetting] for optimistic updates.
  Future<Result<AppSetting>> setDouble(String key, double value);

  /// Deletes a setting by key.
  /// Returns the deleted key for optimistic updates.
  Future<Result<String>> deleteSetting(String key);

  /// Deletes all settings matching a prefix.
  Future<Result<int>> deleteSettingsByPrefix(String prefix);
}
