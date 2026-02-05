import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:habits_app/core/constants/app_values.dart';

part 'theme_provider.g.dart';

@riverpod
class AppThemeMode extends _$AppThemeMode {
  late Box _box;
  
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  Future<void> init() async {
    _box = await Hive.openBox(AppValues.themeBoxName);
    final isDark = _box.get(AppValues.isDarkThemeKey);
    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    await _box.put(AppValues.isDarkThemeKey, isDark);
  }
}
