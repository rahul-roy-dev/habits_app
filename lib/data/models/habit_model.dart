import 'package:hive_ce/hive.dart';
import 'package:habits_app/core/constants/app_values.dart';

part 'habit_model.g.dart';

@HiveType(typeId: AppValues.hiveHabitTypeId)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String icon;

  @HiveField(6)
  final int color;

  @HiveField(7)
  final List<DateTime> completionDates;

  @HiveField(8)
  final String userId;

  HabitModel({
    required this.id,
    required this.title,
    this.description = AppValues.defaultHabitDescription,
    this.isCompleted = false,
    required this.createdAt,
    this.icon = AppValues.defaultHabitIcon,
    this.color = AppValues.defaultHabitColor,
    this.completionDates = const [],
    required this.userId,
  });

  HabitModel copyWith({
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
    return HabitModel(
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
}
