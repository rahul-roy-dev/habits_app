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
  });

  static DateTime normalizeDate(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  /// True if this habit should be shown on [date]. Daily (no selected weekdays)
  /// appears every day; weekly appears only when [date].weekday is in
  /// [selectedWeekdays].
  bool appearsOnDate(DateTime date) {
    final normalized = normalizeDate(date);
    if (selectedWeekdays.isEmpty) return true;
    return selectedWeekdays.contains(normalized.weekday);
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
          alertMinute == other.alertMinute;

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
      );
}
