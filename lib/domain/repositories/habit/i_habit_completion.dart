import 'package:habits_app/domain/entities/habit_entity.dart';

/// Interface for habit completion operations
abstract class IHabitCompletion {
  Future<void> toggleHabitCompletion(HabitEntity habit, DateTime date);
  bool isCompletedOnDate(HabitEntity habit, DateTime date);
}
