import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/core/constants/lucide_icons_list.dart';

class AppValues {
  AppValues._();

  // Default Values
  static const int defaultHabitColor = 0xFFA78BFA;
  static const String defaultHabitIcon = 'droplets';
  static const String defaultHabitDescription = '';

  // Preferences Keys (e.g. SharedPreferences)
  static const String isDarkThemeKey = 'is_dark';
  static const String reminderAckKeyPrefix = 'reminder_ack_';

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
  static final Map<String, IconData> habitIconMap = {
    'dumbbell': LucideIcons.dumbbell,
    'droplets': LucideIcons.droplets,
    'bookOpen': LucideIcons.book_open,
    'hand': LucideIcons.hand, 
    'utensils': LucideIcons.utensils,
    'moon': LucideIcons.moon,
    'code': LucideIcons.code,
    'ellipsis': LucideIcons.ellipsis,
  };

  /// Centralized icon resolution. Resolves from habitIconMap, then full Lucide set.
  static IconData getIconData(String name) {
    return habitIconMap[name] ?? lucideIconsMap[name] ?? Icons.help_outline;
  }

  /// Display names for habit icons (category labels on Statistics Top Streaks).
  static const Map<String, String> habitIconDisplayNames = {
    'dumbbell': 'Workout',
    'droplets': 'Hydration',
    'book-open': 'Reading',
    'peace': 'Meditation',
    'utensils': 'Nutrition',
    'moon': 'Sleep',
    'code': 'Code',
    'more-horizontal': 'Other',
  };


  // Frequency Options
  static const String frequencyDaily = 'Daily';
  static const String frequencyWeekly = 'Weekly';

  // Default Frequency
  static const String defaultFrequency = 'Daily';

  // Reminder / notification timing (Clean Architecture: single source of truth)
  /// Interval (seconds) for checking if we should show in-app overlay when app is in foreground.
  static const int foregroundReminderCheckIntervalSeconds = 30;
  /// Delay (seconds) before retrying notification-tap handling when habit list was not loaded yet.
  static const int notificationTapRetryDelaySeconds = 2;
  /// Delay (ms) after app resume before handling launch-from-notification (lets navigator be ready).
  static const int launchDetailsDelayMs = 400;
  /// Max duration (minutes) the reminder ringtone plays before auto-stop.
  static const int reminderRingtoneMaxDurationMinutes = 1;
  /// Delay (ms) before starting ringtone after overlay is shown (e.g. for screen-off launch).
  static const int reminderRingtoneStartDelayMs = 600;
  /// Delay (ms) before retrying ringtone play if first attempt failed.
  static const int reminderRingtoneRetryDelayMs = 800;

  // Slot key / date formatting
  /// Number of digits for month, day, hour, minute in reminder slot key (padLeft).
  static const int slotKeyPadWidth = 2;
  /// Weekday range for scheduling: first weekday index (1 = Monday).
  static const int weekdayFirst = 1;
  /// Weekday range: last weekday index (7 = Sunday). Use with [daysInWeek].
  static const int weekdayLast = 7;
}
