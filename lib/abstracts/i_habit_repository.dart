import 'package:habits_app/data/models/habit_model.dart';

abstract class IHabitRepository {
  Future<void> init();
  Future<void> addHabit(HabitModel habit);
  List<HabitModel> getHabitsForUser(String userId);
  Future<void> updateHabit(dynamic key, HabitModel habit);
  Future<void> deleteHabit(HabitModel habit);
  Future<void> toggleHabitCompletion(HabitModel habit, DateTime date);
}
