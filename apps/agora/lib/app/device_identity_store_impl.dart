import 'package:database/database.dart';
import 'package:feature_settings/data/sources/local/daos/app_settings_dao.dart';
import 'package:sync_engine/sync_engine.dart';

/// [DeviceIdentityStore] backed by [AppSettingsDao]. `sync_engine` cannot
/// depend on `feature_settings` (packages must not depend on features), so
/// this adapter lives here in the app shell and is resolved once in
/// `main.dart` before the provider tree is built.
class AppSettingsDeviceIdentityStore implements DeviceIdentityStore {
  AppSettingsDeviceIdentityStore(this._dao);

  final AppSettingsDao _dao;

  @override
  Future<String?> read() => _dao.getString(SettingsKeys.syncDeviceId);

  @override
  Future<void> write(String deviceId) =>
      _dao.setString(SettingsKeys.syncDeviceId, deviceId);
}
