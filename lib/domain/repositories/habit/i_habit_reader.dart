import 'package:habits_app/domain/entities/habit_entity.dart';

/// Interface for reading habit data
abstract class IHabitReader {
  List<HabitEntity> getHabitsForUser(String userId);
  
  HabitEntity? getHabitById(String habitId);
}
