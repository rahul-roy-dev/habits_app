import 'package:flutter/material.dart';

class AppValues {
  AppValues._();

  // Hive Type IDs
  static const int hiveUserTypeId = 0;
  static const int hiveHabitTypeId = 1;

  // Default Values
  static const int defaultHabitColor = 0xFFA78BFA;
  static const String defaultHabitIcon = 'water';
  static const String defaultHabitDescription = '';

  // Box Names
  static const String userBoxName = 'userBox';
  static const String sessionBoxName = 'sessionBox';
  static const String habitBoxName = 'habitBox';
  static const String themeBoxName = 'theme_box';

  // Keys
  static const String currentUserKey = 'currentUser';
  static const String isDarkThemeKey = 'is_dark';

  // Default Selected Days
  static const List<String> defaultSelectedDays = ['M', 'T', 'W', 'T', 'F'];

  // Days of Week
  static const List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Habit Colors
  static const List<int> habitColors = [
    0xFFA78BFA,
    0xFF3B82F6,
    0xFF10B981,
    0xFFF59E0B,
    0xFFEF4444,
    0xFFEC4899,
    0xFF06B6D4,
  ];

  // Habit Icons Map
  static const Map<String, IconData> habitIconMap = {
    'workout': Icons.fitness_center,
    'water': Icons.local_drink,
    'book': Icons.menu_book,
    'meditation': Icons.self_improvement,
    'food': Icons.restaurant,
    'sleep': Icons.nightlight_round,
    'code': Icons.code,
    'other': Icons.more_horiz,
  };


  // Frequency Options
  static const String frequencyDaily = 'Daily';
  static const String frequencyWeekly = 'Weekly';

  // Default Frequency
  static const String defaultFrequency = 'Daily';
}
