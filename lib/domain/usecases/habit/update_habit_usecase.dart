import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';

/// Use case for updating an existing habit
class UpdateHabitUseCase {
  final IHabitWriter _habitWriter;

  UpdateHabitUseCase(this._habitWriter);


  Future<void> execute(String habitId, HabitEntity habit) async {
    await _habitWriter.updateHabit(habitId, habit);
  }
}
