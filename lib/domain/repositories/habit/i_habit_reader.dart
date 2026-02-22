import 'package:habits_app/domain/entities/habit_entity.dart';

/// Interface for reading habit data (async for cloud backends e.g. Firestore)
abstract class IHabitReader {
  Future<List<HabitEntity>> getHabitsForUser(String userId);

  Future<HabitEntity?> getHabitById(String habitId);
}
