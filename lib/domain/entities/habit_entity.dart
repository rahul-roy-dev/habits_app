/// How a habit's end is defined. Serialized to Firestore as enum name.
enum HabitEndMode { none, onDate, afterDays }

/// Domain entity for a habit. Defaults are kept in sync with [AppValues] in core.
class HabitEntity {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String icon;
  final int color;
  final List<DateTime> completionDates;
  final String userId;
  final List<int> selectedWeekdays;
  final int? alertHour;
  final int? alertMinute;
  /// No end, fixed calendar last day, or challenge length from [createdAt].
  final HabitEndMode endMode;
  /// Inclusive last calendar day the habit is active (local date). Set when [endMode] is [HabitEndMode.onDate] or [HabitEndMode.afterDays].
  final DateTime? endDate;
  /// Stored when [endMode] is [HabitEndMode.afterDays] so the edit form can show the same duration.
  final int? endAfterDays;

  static const String _defaultDescription = '';
  static const String _defaultIcon = 'droplets';
  static const int _defaultColor = 0xFFA78BFA;

  const HabitEntity({
    required this.id,
    required this.title,
    this.description = _defaultDescription,
    this.isCompleted = false,
    required this.createdAt,
    this.icon = _defaultIcon,
    this.color = _defaultColor,
    this.completionDates = const [],
    required this.userId,
    this.selectedWeekdays = const [],
    this.alertHour,
    this.alertMinute,
    this.endMode = HabitEndMode.none,
    this.endDate,
    this.endAfterDays,
  });

  static DateTime normalizeDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  /// True if this habit should be shown on [date]. Daily (no selected weekdays)
  /// appears every day; weekly appears only when [date].weekday is in
  /// [selectedWeekdays]. Dates after [endDate] never apply.
  bool appearsOnDate(DateTime date) {
    final normalized = normalizeDate(date);
    if (endDate != null) {
      final end = normalizeDate(endDate!);
      if (normalized.isAfter(end)) return false;
    }
    if (selectedWeekdays.isEmpty) return true;
    return selectedWeekdays.contains(normalized.weekday);
  }

  /// Last active calendar day (inclusive), from duration counted from [anchor] (typically [createdAt]).
  static DateTime endDateAfterDaysFrom(DateTime anchor, int days) {
    final start = normalizeDate(anchor);
    return start.add(Duration(days: days - 1));
  }

  /// Resolves persisted end fields from UI mode. [anchorCreatedAt] is the habit creation instant (edit: existing).
  static ({HabitEndMode mode, DateTime? endDate, int? endAfterDays}) resolveEndFields({
    required HabitEndMode endMode,
    required DateTime anchorCreatedAt,
    DateTime? pickedEndDate,
    int? durationDays,
    required int minDays,
    required int maxDays,
    required int defaultDays,
  }) {
    switch (endMode) {
      case HabitEndMode.none:
        return (mode: HabitEndMode.none, endDate: null, endAfterDays: null);
      case HabitEndMode.onDate:
        final d = pickedEndDate != null ? normalizeDate(pickedEndDate) : null;
        return (mode: HabitEndMode.onDate, endDate: d, endAfterDays: null);
      case HabitEndMode.afterDays:
        final raw = durationDays ?? defaultDays;
        final n = raw.clamp(minDays, maxDays);
        final end = endDateAfterDaysFrom(anchorCreatedAt, n);
        return (mode: HabitEndMode.afterDays, endDate: end, endAfterDays: n);
    }
  }

  bool isCompletedOnDate(DateTime date) {
    final normalized = normalizeDate(date);
    return completionDates.any((d) =>
        d.year == normalized.year &&
        d.month == normalized.month &&
        d.day == normalized.day);
  }

  HabitEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? icon,
    int? color,
    List<DateTime>? completionDates,
    String? userId,
    List<int>? selectedWeekdays,
    int? alertHour,
    int? alertMinute,
    bool clearAlertTime = false,
    HabitEndMode? endMode,
    DateTime? endDate,
    int? endAfterDays,
    bool clearEnd = false,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      completionDates: completionDates ?? this.completionDates,
      userId: userId ?? this.userId,
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      alertHour: clearAlertTime ? null : (alertHour ?? this.alertHour),
      alertMinute: clearAlertTime ? null : (alertMinute ?? this.alertMinute),
      endMode: clearEnd ? HabitEndMode.none : (endMode ?? this.endMode),
      endDate: clearEnd ? null : (endDate ?? this.endDate),
      endAfterDays: clearEnd ? null : (endAfterDays ?? this.endAfterDays),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt &&
          icon == other.icon &&
          color == other.color &&
          completionDates == other.completionDates &&
          userId == other.userId &&
          selectedWeekdays == other.selectedWeekdays &&
          alertHour == other.alertHour &&
          alertMinute == other.alertMinute &&
          endMode == other.endMode &&
          endDate == other.endDate &&
          endAfterDays == other.endAfterDays;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        isCompleted,
        createdAt,
        icon,
        color,
        completionDates,
        userId,
        Object.hashAll(selectedWeekdays),
        alertHour,
        alertMinute,
        endMode,
        endDate,
        endAfterDays,
      );
}
