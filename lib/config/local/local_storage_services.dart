import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get instance async => _preferences ??= await SharedPreferences.getInstance();

  static Future<bool> saveData<T>(LocalStorageKeys key, T value) async {
    if (_preferences?.containsKey(key.toString()) ?? false) {
      await deleteData(key);
    }
    if (T == String) {
      return await _preferences?.setString(key.toString(), value as String) ?? false;
    } else if (T == int) {
      return await _preferences?.setInt(key.toString(), value as int) ?? false;
    } else if (T == bool) {
      return await _preferences?.setBool(key.toString(), value as bool) ?? false;
    } else {
      return await _preferences?.setString(key.toString(), jsonEncode(value).toString()) ?? false;
    }
  }

  static T? getData<T>(LocalStorageKeys key) {
    if (T == String) {
      return _preferences?.getString(key.toString()) as T?;
    } else if (T == int) {
      return _preferences?.getInt(key.toString()) as T?;
    } else if (T == bool) {
      return _preferences?.getBool(key.toString()) as T?;
    } else {
      final jsonString = _preferences?.getString(key.toString());
      if (jsonString != null) return jsonDecode(jsonString) as T?;
    }
    return null;
  }

  static List<T> getListData<T>(LocalStorageKeys key, {required T? Function(Map<String, dynamic> json) fromJson}) {
    final jsonString = _preferences?.getString(key.toString());
    if (jsonString != null) {
      return List<T>.from(jsonDecode(jsonString).map((e) => fromJson(e)).toList());
    }
    return [];
  }

  static Future<bool> deleteData(LocalStorageKeys key) async {
    if (_preferences?.containsKey(key.toString()) ?? false) {
      return await _preferences?.remove(key.toString()) ?? false;
    }
    return false;
  }

  static Future<bool?> clearData() async {
    return await deleteData(LocalStorageKeys.authToken);
  }

  static String? authToken() => getData<String>(LocalStorageKeys.authToken);
  static bool isVan() => getData<bool>(LocalStorageKeys.isVan) ?? false;
}

enum LocalStorageKeys { authToken, isVan }
