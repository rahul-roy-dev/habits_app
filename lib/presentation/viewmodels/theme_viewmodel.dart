import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:habits_app/core/constants/app_values.dart';

class ThemeViewModel extends ChangeNotifier {
  late Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    _box = await Hive.openBox(AppValues.themeBoxName);
    final isDark = _box.get(AppValues.isDarkThemeKey);
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _box.put(AppValues.isDarkThemeKey, isDark);
    notifyListeners();
  }
}
