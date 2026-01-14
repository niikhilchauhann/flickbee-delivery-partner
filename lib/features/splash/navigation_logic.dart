import 'package:shared_preferences/shared_preferences.dart';

class DriverSession {
  static final _prefs = SharedPreferences.getInstance();

  static Future<void> setLoggedIn(bool value) async {
    final p = await _prefs;
    await p.setBool('logged_in', value);
  }

  static Future<bool> isLoggedIn() async {
    final p = await _prefs;
    return p.getBool('logged_in') ?? false;
  }

  static Future<void> setStoreSelected(String storeId) async {
    final p = await _prefs;
    await p.setString('store_id', storeId);
  }

  static Future<bool> hasStore() async {
    final p = await _prefs;
    return p.containsKey('store_id');
  }
}
