import 'package:shared_preferences/shared_preferences.dart';

enum Keys {
  name,
  number,
  email,
}

class SharedPrefrencess {
  SharedPrefrencess._();

  static Future<void> save(Keys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key.toString(), value);
  }

  // static Future<void> fetch(Keys key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.getString(key.toString());
  // }

  static Future<void> remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
