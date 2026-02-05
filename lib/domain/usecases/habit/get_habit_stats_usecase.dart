import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';

/// Parameters for get completion progress use case
class GetCompletionProgressParams {
  final String userId;
  final DateTime date;

  const GetCompletionProgressParams({
    required this.userId,
    required this.date,
  });
}

/// Parameters for get completed count use case
class GetCompletedCountParams {
  final String userId;
  final DateTime date;

  const GetCompletedCountParams({
    required this.userId,
    required this.date,
  });
}

/// Parameters for get total habits use case
class GetTotalHabitsParams {
  final String userId;

  const GetTotalHabitsParams({required this.userId});
}

/// Use case for calculating habit statistics
class GetHabitStatsUseCase {
  final IHabitReader _habitReader;

  GetHabitStatsUseCase(this._habitReader);

  /// Get the completion progress for a specific date
  double getCompletionProgress(String userId, DateTime date) {
    final habits = _habitReader.getHabitsForUser(userId);
    if (habits.isEmpty) return 0.0;

    int completedCount = 0;
    for (var habit in habits) {
      bool isCompletedOnDate = habit.completionDates.any(
        (d) => d.year == date.year && d.month == date.month && d.day == date.day,
      );
      if (isCompletedOnDate) completedCount++;
    }

    return completedCount / habits.length;
  }

  /// Get the count of completed habits for a specific date
  int getCompletedCount(String userId, DateTime date) {
    final habits = _habitReader.getHabitsForUser(userId);
    return habits
        .where(
          (habit) => habit.completionDates.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          ),
        )
        .length;
  }

  /// Get total number of habits for a user
  int getTotalHabits(String userId) {
    return _habitReader.getHabitsForUser(userId).length;
  }
}
