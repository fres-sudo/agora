import 'package:database/database.dart';

import 'device_id.dart';

/// Persistence seam for [DeviceIdentityService]. `sync_engine` cannot
/// depend on `feature_settings` (packages must not depend on features), so
/// the concrete store — backed by `AppSettingsDao` — is implemented in the
/// app shell and injected here.
abstract interface class DeviceIdentityStore {
  Future<String?> read();
  Future<void> write(String deviceId);
}

/// Resolves this install's stable [DeviceId], generating and persisting
/// one on first run if none exists yet.
class DeviceIdentityService {
  DeviceIdentityService({required DeviceIdentityStore store}) : _store = store;

  final DeviceIdentityStore _store;

  Future<DeviceId> getOrCreateDeviceId() async {
    final existing = await _store.read();
    if (existing != null) return DeviceId(existing);

    final generated = generateSyncId();
    await _store.write(generated);
    return DeviceId(generated);
  }
}
