import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _preferences!.setString(key, value);
    } else if (value is List) {
      await _preferences!.setString(key, jsonEncode(value));
    } else if (value is Map) {
      await _preferences!.setString(key, jsonEncode(value));
    } else if (value is bool) {
      await _preferences!.setBool(key, value);
    } else if (value is int) {
      await _preferences!.setInt(key, value);
    } else if (value is double) {
      await _preferences!.setDouble(key, value);
    }
  }

  dynamic getData(String key) {
    return _preferences!.get(key);
  }

  String? getString(String key) => _preferences!.getString(key);

  int? getInt(String key) => _preferences!.getInt(key);

  bool? getBool(String key) => _preferences!.getBool(key);

  double? getDouble(String key) => _preferences!.getDouble(key);

  Future<void> removeData(String key) async {
    await _preferences!.remove(key);
  }

  Future<void> clearAll() async {
    await _preferences!.clear();
  }
}
