import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  static const String pinKey = "user_pin";
  Future<String?> getPin();
  Future<void> setPin(String pin);
  Future<void> deleteAll();
}

class SecureStorageService implements StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<String?> getPin() async =>
      await _storage.read(key: StorageService.pinKey);

  @override
  Future<void> setPin(String pin) async =>
      await _storage.write(key: StorageService.pinKey, value: pin);
}
