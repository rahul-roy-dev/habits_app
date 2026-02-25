import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_completion.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for toggle habit use case
class ToggleHabitParams {
  final HabitEntity habit;
  final DateTime date;

  const ToggleHabitParams({
    required this.habit,
    required this.date,
  });
}

/// Use case for toggling habit completion status
class ToggleHabitUseCase extends BaseUseCase<void, ToggleHabitParams> {
  final IHabitCompletion _habitCompletion;

  ToggleHabitUseCase(this._habitCompletion);

  @override
  Future<void> call(ToggleHabitParams params) async {
    await _habitCompletion.toggleHabitCompletion(params.habit, params.date);
  }

  Future<void> execute(HabitEntity habit, DateTime date) async {
    return await call(ToggleHabitParams(habit: habit, date: date));
  }
}
