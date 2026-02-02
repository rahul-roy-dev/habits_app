import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_completion.dart';

/// Use case for toggling habit completion status
class ToggleHabitUseCase {
  final IHabitCompletion _habitCompletion;

  ToggleHabitUseCase(this._habitCompletion);

  Future<void> execute(HabitEntity habit, DateTime date) async {
    await _habitCompletion.toggleHabitCompletion(habit, date);
  }
}
