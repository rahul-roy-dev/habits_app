import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/services/reminder_overlay_navigator.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  List<HabitEntity> _monitoredHabits = [];
  Timer? _foregroundTimer;
  final Set<String> _pendingAckSlotKeys = {};
  bool _isReminderOverlayVisible = false;
  ReminderOverlayNavigator? _overlayNavigator;

  /// Injected by composition root (main). Core depends on abstraction only (DIP).
  void setReminderOverlayNavigator(ReminderOverlayNavigator navigator) {
    _overlayNavigator = navigator;
  }

  Future<void> cancelActiveNotificationForHabit(String habitId) async {
    final notificationId = habitId.hashCode;
    await _notifications.cancel(notificationId);
    for (var weekday = AppValues.weekdayFirst; weekday <= AppValues.weekdayLast; weekday++) {
      await _notifications.cancel(notificationId + weekday);
    }
  }

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    
    try {
      final location = tz.getLocation('Asia/Jakarta');
      tz.setLocalLocation(location);
    } catch (e) {
      debugPrint('Failed to set timezone: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );


    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      for (final id in ['habit_reminders_urgent_v2', 'habit_reminders_urgent_v3']) {
        await androidPlugin.deleteNotificationChannel(id);
      }
    }

    _initialized = true;
    _startForegroundMonitoring();
  }

  void updateMonitoredHabits(List<HabitEntity> habits) {
    _monitoredHabits = habits;
  }

  void _startForegroundMonitoring() {
    _foregroundTimer?.cancel();
    _foregroundTimer = Timer.periodic(
      const Duration(seconds: AppValues.foregroundReminderCheckIntervalSeconds),
      (timer) => _checkForegroundReminders(),
    );
  }

  void _checkForegroundReminders() {
    final now = DateTime.now();
    for (final habit in _monitoredHabits) {
      if (habit.alertHour == now.hour && habit.alertMinute == now.minute) {
        // If it's a weekly habit, check day
        if (habit.selectedWeekdays.isNotEmpty &&
            !habit.selectedWeekdays.contains(now.weekday)) {
          continue;
        }
        _showForegroundOverlay(habit);
      }
    }
  }

  static String _reminderSlotKey(HabitEntity habit, DateTime date) {
    final pad = AppValues.slotKeyPadWidth;
    final y = date.year;
    final m = date.month.toString().padLeft(pad, '0');
    final d = date.day.toString().padLeft(pad, '0');
    final h = (habit.alertHour ?? 0).toString().padLeft(pad, '0');
    final min = (habit.alertMinute ?? 0).toString().padLeft(pad, '0');
    return '${AppValues.reminderAckKeyPrefix}${habit.id}_$y$m${d}_${h}_$min';
  }

  Future<void> _showForegroundOverlay(HabitEntity habit) async {
    // Prevent double overlay - check if already visible
    if (_isReminderOverlayVisible) {
      return;
    }
    
    final now = DateTime.now();
    final slotKey = _reminderSlotKey(habit, now);
    if (_pendingAckSlotKeys.contains(slotKey)) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get(slotKey) != null) {
      return;
    }

    _pendingAckSlotKeys.add(slotKey);
    await prefs.setString(slotKey, '1');
    _isReminderOverlayVisible = true;

    // Cancel the system notification (and its sound) since we are showing
    await cancelActiveNotificationForHabit(habit.id);

    debugPrint('Triggering foreground overlay for ${habit.id}');
    _overlayNavigator?.pushReminderOverlay(
      habitId: habit.id,
      reminderSlotKey: slotKey,
      onPopped: () => _isReminderOverlayVisible = false,
    );
  }

  /// Call when user taps "Dismiss for now" or "MARK COMPLETED" so this reminder
  Future<void> markReminderAcknowledged(String reminderSlotKey) async {
    _pendingAckSlotKeys.remove(reminderSlotKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(reminderSlotKey, '1');
  }

  /// Call when the user updates reminder settings (e.g. alert time) so the
  /// fullscreen overlay can show again for the next occurrence.
  Future<void> clearReminderAcknowledgementsForHabit(String habitId) async {
    final prefix = '${AppValues.reminderAckKeyPrefix}${habitId}_';
    _pendingAckSlotKeys.removeWhere((k) => k.startsWith(prefix));
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(prefix)).toList();
    for (final k in keys) {
      await prefs.remove(k);
    }
  }

  Future<void> _onNotificationTapped(
    NotificationResponse response, {
    bool isLaunchDetailsRetry = false,
  }) async {
    debugPrint('Notification tapped: ${response.payload}');
    if (response.payload == null) return;

    if (_isReminderOverlayVisible) return;

    final habitId = response.payload!;
    HabitEntity? habit;
    for (final h in _monitoredHabits) {
      if (h.id == habitId) {
        habit = h;
        break;
      }
    }


    if (habit == null) {
      if (!isLaunchDetailsRetry) {
        Future.delayed(
          const Duration(seconds: AppValues.notificationTapRetryDelaySeconds),
          () => _onNotificationTapped(response, isLaunchDetailsRetry: true),
        );
      }
      return;
    }

    final now = DateTime.now();
    final slotKey = _reminderSlotKey(habit, now);
    if (_pendingAckSlotKeys.contains(slotKey)) return;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.get(slotKey) != null) return;

    await prefs.setString(slotKey, '1');
    _pendingAckSlotKeys.add(slotKey);
    _isReminderOverlayVisible = true;
    _overlayNavigator?.pushReminderOverlay(
      habitId: habitId,
      reminderSlotKey: slotKey,
      onPopped: () => _isReminderOverlayVisible = false,
    );
  }

  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    bool? granted;
    if (android != null) {
      granted = await android.requestNotificationsPermission();
      
      await android.requestExactAlarmsPermission();
    }
    if (ios != null) {
      granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return granted ?? false;
  }

  static const String _habitReminderChannelId = 'habit_reminders_urgent_v4';

  Future<void> scheduleHabitReminder(HabitEntity habit) async {
    if (habit.alertHour == null || habit.alertMinute == null) return;

    await cancelHabitReminder(habit.id);

    final notificationId = habit.id.hashCode;
    final title = 'Habit Reminder';
    final body = 'Time to complete: ${habit.title}';

    // Schedule for each selected weekday or daily
    if (habit.selectedWeekdays.isEmpty) {
      await _scheduleDailyNotification(
        id: notificationId,
        title: title,
        body: body,
        hour: habit.alertHour!,
        minute: habit.alertMinute!,
        payload: habit.id,
      );
    } else {
      // Weekly reminders for each selected day
      for (final weekday in habit.selectedWeekdays) {
        await _scheduleWeeklyNotification(
          id: notificationId + weekday,
          title: title,
          body: body,
          weekday: weekday,
          hour: habit.alertHour!,
          minute: habit.alertMinute!,
          payload: habit.id,
        );
      }
    }
  }

  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _habitReminderChannelId,
      'Habit Reminders (Urgent)',
      channelDescription: 'Urgent full screen notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('soar_binaural_beat'),
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(hour, minute),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
      debugPrint('Scheduled daily notification for $hour:$minute');
    } catch (e) {
      debugPrint('Failed to schedule with exact mode: $e');
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          _nextInstanceOfTime(hour, minute),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: payload,
        );
      } catch (e2) {
        debugPrint('Failed to schedule with inexact mode: $e2');
      }
    }
  }

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _habitReminderChannelId,
      'Habit Reminders (Urgent)',
      channelDescription: 'Urgent full screen notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.reminder,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('soar_binaural_beat'),
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfDayAndTime(weekday, hour, minute),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );
      debugPrint('Scheduled weekly notification for weekday $weekday at $hour:$minute');
    } catch (e) {
      debugPrint('Failed to schedule with exact mode: $e');
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          _nextInstanceOfDayAndTime(weekday, hour, minute),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: payload,
        );
      } catch (e2) {
        debugPrint('Failed to schedule with inexact mode: $e2');
      }
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int weekday, int hour, int minute) {
    var scheduledDate = _nextInstanceOfTime(hour, minute);
    // weekday: 1=Monday, 7=Sunday (Dart DateTime format)
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelHabitReminder(String habitId) async {
    final notificationId = habitId.hashCode;
    await _notifications.cancel(notificationId);

    // Cancel all weekday-based notifications (1-7)
    for (var weekday = AppValues.weekdayFirst; weekday <= AppValues.weekdayLast; weekday++) {
      await _notifications.cancel(notificationId + weekday);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }



  Future<void> handleAppResumed() async {
    if (!_initialized) return;
    final launchDetails = await _notifications.getNotificationAppLaunchDetails();
    if (launchDetails == null || !launchDetails.didNotificationLaunchApp) return;
    final payload = launchDetails.notificationResponse?.payload;
    if (payload == null) return;
    await Future.delayed(const Duration(milliseconds: AppValues.launchDetailsDelayMs));
    await _onNotificationTapped(launchDetails.notificationResponse!, isLaunchDetailsRetry: false);
  }

  static Future<void> openFullScreenIntentSettings() async {
    if (!kIsWeb) {
      try {
        await const MethodChannel('com.example.habits_app/full_screen_intent')
            .invokeMethod<void>('openFullScreenIntentSettings');
      } catch (_) {}
    }
  }
}
