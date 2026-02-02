import 'package:habits_app/domain/entities/habit_entity.dart';

/// Interface for writing habit data
abstract class IHabitWriter {
  Future<void> addHabit(HabitEntity habit);
  
  Future<void> updateHabit(String habitId, HabitEntity habit);
  
  Future<void> deleteHabit(HabitEntity habit);
}
