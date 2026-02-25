import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for delete habit use case
class DeleteHabitParams {
  final HabitEntity habit;

  const DeleteHabitParams({required this.habit});
}

/// Use case for deleting a habit
class DeleteHabitUseCase extends BaseUseCase<void, DeleteHabitParams> {
  final IHabitWriter _habitWriter;

  DeleteHabitUseCase(this._habitWriter);

  @override
  Future<void> call(DeleteHabitParams params) async {
    await _habitWriter.deleteHabit(params.habit);
  }

  Future<void> execute(HabitEntity habit) async {
    return await call(DeleteHabitParams(habit: habit));
  }
}
