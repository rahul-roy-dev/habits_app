import 'package:habits_app/core/constants/app_values.dart';

class HabitEntity {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String icon;
  final int color;
  final List<DateTime> completionDates;
  final String? userId;

  const HabitEntity({
    required this.id,
    required this.title,
    this.description = AppValues.defaultHabitDescription,
    this.isCompleted = false,
    required this.createdAt,
    this.icon = AppValues.defaultHabitIcon,
    this.color = AppValues.defaultHabitColor,
    this.completionDates = const [],
    this.userId,
  });

  bool isCompletedOnDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
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
          userId == other.userId;

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
      );
}
