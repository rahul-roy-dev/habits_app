import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for update habit use case
class UpdateHabitParams {
  final String habitId;
  final HabitEntity habit;

  const UpdateHabitParams({
    required this.habitId,
    required this.habit,
  });
}

/// Use case for updating an existing habit
class UpdateHabitUseCase extends BaseUseCase<void, UpdateHabitParams> {
  final IHabitWriter _habitWriter;

  UpdateHabitUseCase(this._habitWriter);

  @override
  Future<void> call(UpdateHabitParams params) async {
    await _habitWriter.updateHabit(params.habitId, params.habit);
  }

  Future<void> execute(String habitId, HabitEntity habit) async {
    return await call(UpdateHabitParams(habitId: habitId, habit: habit));
  }
}
