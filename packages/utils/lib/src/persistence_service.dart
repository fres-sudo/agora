import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistenceService {
  Future<void> saveInt(String key, int value);
  int? getInt(String key);

  Future<void> saveDouble(String key, double value);
  double? getDouble(String key);

  Future<void> saveString(String key, String value);
  String? getString(String key);

  // unnecessary named because the type is extremely clear with the method name
  // ignore: avoid_positional_boolean_parameters
  Future<void> saveBool(String key, bool value);
  bool? getBool(String key);

  Future<void> saveStringList(String key, List<String> value);
  List<String>? getStringList(String key);

  Future<void> remove(String key);
  Future<void> clear();
}

class PersistenceServiceImpl implements PersistenceService {
  const PersistenceServiceImpl();

  static SharedPreferences? instance;

  @override
  Future<void> saveInt(String key, int value) async {
    await instance?.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return instance?.getInt(key);
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    await instance?.setDouble(key, value);
  }

  @override
  double? getDouble(String key) {
    return instance?.getDouble(key);
  }

  @override
  Future<void> saveString(String key, String value) async {
    await instance?.setString(key, value);
  }

  @override
  String? getString(String key) {
    return instance?.getString(key);
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    await instance?.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return instance?.getBool(key);
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    await instance?.setStringList(key, value);
  }

  @override
  List<String>? getStringList(String key) {
    return instance?.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    await instance?.remove(key);
  }

  @override
  Future<void> clear() async {
    await instance?.clear();
  }
}
