import 'package:agora/core/database/database.dart';
import 'package:agora/core/misc/repository.dart';
import 'package:agora/core/misc/result.dart';
import 'package:agora/settings/services/local/daos/app_settings_dao.dart';
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

/// Implementation of [SettingsRepository] using Drift DAOs.
class SettingsRepositoryImpl extends Repository implements SettingsRepository {
  SettingsRepositoryImpl({
    required AppSettingsDao appSettingsDao,
    Talker? logger,
  }) : _appSettingsDao = appSettingsDao,
       super(logger);

  final AppSettingsDao _appSettingsDao;

  // ============================================================
  // HELPERS
  // ============================================================

  AppSetting _entityToModel(AppSettingEntity entity) {
    return (key: entity.key, value: entity.value, type: entity.type);
  }

  // ============================================================
  // STREAMS
  // ============================================================

  @override
  Stream<List<AppSetting>> watchAllSettings() {
    return _appSettingsDao
        .watchAllSettings()
        .map((entities) => entities.map(_entityToModel).toList())
        .safeCode(logger);
  }

  @override
  Stream<String?> watchSettingValue(String key) {
    return _appSettingsDao
        .watchSettingByKey(key)
        .map((entity) => entity?.value)
        .safeCode(logger);
  }

  @override
  Stream<List<AppSetting>> watchSettingsByPrefix(String prefix) {
    return _appSettingsDao
        .watchSettingsByPrefix(prefix)
        .map((entities) => entities.map(_entityToModel).toList())
        .safeCode(logger);
  }

  // ============================================================
  // READ OPERATIONS
  // ============================================================

  @override
  Future<Result<String?>> getString(String key) =>
      safe('getString($key)', () => _appSettingsDao.getString(key));

  @override
  Future<Result<int?>> getInt(String key) =>
      safe('getInt($key)', () => _appSettingsDao.getInt(key));

  @override
  Future<Result<bool?>> getBool(String key) =>
      safe('getBool($key)', () => _appSettingsDao.getBool(key));

  @override
  Future<Result<double?>> getDouble(String key) =>
      safe('getDouble($key)', () => _appSettingsDao.getDouble(key));

  @override
  Future<Result<List<AppSetting>>> getPrinterSettings() =>
      safe('getPrinterSettings', () async {
        final entities = await _appSettingsDao.getPrinterSettings();
        return entities.map(_entityToModel).toList();
      });

  @override
  Future<Result<List<AppSetting>>> getReceiptSettings() =>
      safe('getReceiptSettings', () async {
        final entities = await _appSettingsDao.getReceiptSettings();
        return entities.map(_entityToModel).toList();
      });

  // ============================================================
  // WRITE OPERATIONS - Optimistic Update Support
  // ============================================================

  @override
  Future<Result<AppSetting>> setString(String key, String value) =>
      safe('setString($key)', () async {
        await _appSettingsDao.setString(key, value);
        return (key: key, value: value, type: AppSettingsDao.typeString);
      });

  @override
  Future<Result<AppSetting>> setInt(String key, int value) => safe(
    'setInt($key)',
    () async {
      await _appSettingsDao.setInt(key, value);
      return (key: key, value: value.toString(), type: AppSettingsDao.typeInt);
    },
  );

  @override
  Future<Result<AppSetting>> setBool(String key, bool value) => safe(
    'setBool($key)',
    () async {
      await _appSettingsDao.setBool(key, value);
      return (key: key, value: value.toString(), type: AppSettingsDao.typeBool);
    },
  );

  @override
  Future<Result<AppSetting>> setDouble(String key, double value) =>
      safe('setDouble($key)', () async {
        await _appSettingsDao.setDouble(key, value);
        return (
          key: key,
          value: value.toString(),
          type: AppSettingsDao.typeString,
        );
      });

  @override
  Future<Result<String>> deleteSetting(String key) =>
      safe('deleteSetting($key)', () async {
        await _appSettingsDao.deleteSetting(key);
        return key;
      });

  @override
  Future<Result<int>> deleteSettingsByPrefix(String prefix) => safe(
    'deleteSettingsByPrefix($prefix)',
    () => _appSettingsDao.deleteSettingsByPrefix(prefix),
  );
}
