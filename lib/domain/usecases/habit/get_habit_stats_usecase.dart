import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';

/// Use case for calculating habit statistics
class GetHabitStatsUseCase {
  final IHabitReader _habitReader;

  GetHabitStatsUseCase(this._habitReader);

  /// Get the completion progress for a specific date
  /// Returns a value between 0.0 and 1.0
  Future<double> getCompletionProgress(String userId, DateTime date) async {
    final habits = await _habitReader.getHabitsForUser(userId);
    if (habits.isEmpty) return 0.0;
    final completedCount = habits.where((h) => h.isCompletedOnDate(date)).length;
    return completedCount / habits.length;
  }

  /// Get the count of completed habits for a specific date
  Future<int> getCompletedCount(String userId, DateTime date) async {
    final habits = await _habitReader.getHabitsForUser(userId);
    return habits.where((h) => h.isCompletedOnDate(date)).length;
  }

  /// Get total number of habits for a user
  Future<int> getTotalHabits(String userId) async {
    final habits = await _habitReader.getHabitsForUser(userId);
    return habits.length;
  }
}
