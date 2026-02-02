import 'package:habits_app/domain/entities/habit_entity.dart';

abstract class IHabitRepository {
  Future<void> init();
  Future<void> addHabit(HabitEntity habit);
  List<HabitEntity> getHabitsForUser(String userId);
  Future<void> updateHabit(String habitId, HabitEntity habit);
  Future<void> deleteHabit(HabitEntity habit);
  Future<void> toggleHabitCompletion(HabitEntity habit, DateTime date);
}
