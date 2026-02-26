import 'package:flutter/material.dart';

class AppValues {
  AppValues._();

  // Default Values
  static const int defaultHabitColor = 0xFFA78BFA;
  static const String defaultHabitIcon = 'water';
  static const String defaultHabitDescription = '';

  // Preferences Keys (e.g. SharedPreferences)
  static const String isDarkThemeKey = 'is_dark';

  // Display
  static const int percentageScale = 100;

  /// Number of weekdays (1=Mon .. 7=Sun). Used for weekday picker length.
  static const int daysInWeek = 7;

  /// Default selected weekdays as indices (1=Mon .. 7=Sun). Mon–Fri.
  static const List<int> defaultSelectedWeekdayIndices = [1, 2, 3, 4, 5];

  // Default Selected Days (labels)
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
