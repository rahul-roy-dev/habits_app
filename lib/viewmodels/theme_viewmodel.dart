import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeViewModel extends ChangeNotifier {
  static const _themeBox = 'theme_box';
  static const _isDarkKey = 'is_dark';

  late Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    _box = await Hive.openBox(_themeBox);
    final isDark = _box.get(_isDarkKey);
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _box.put(_isDarkKey, isDark);
    notifyListeners();
  }
}
