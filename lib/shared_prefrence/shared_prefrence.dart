import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys {
  name,
  number,
  email,
}

class SharedPrefrencess {
  SharedPrefrencess._();

  static Future<void> setString(StorageKeys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.name, value);
  }

  static Future<String> getString(StorageKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.name) ?? '';
  }

  static Future<void> remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
