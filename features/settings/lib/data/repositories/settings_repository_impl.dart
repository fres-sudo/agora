import 'package:database/database.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:app_settings/repositories/settings_repository.dart';
import 'package:logger/logger.dart';
import 'package:result/result.dart';

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
          type: AppSettingsDao.typeDouble,
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
