import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode();
    notifyListeners();
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
    notifyListeners();
  }

  Future<void> _saveThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme_mode', _themeMode.index);
  }

  Future<void> remove() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("theme_mode");
    notifyListeners();
  }

  void logout() {
    _themeMode = ThemeMode.system;
    _saveThemeMode();

    notifyListeners();
  }
}
