import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';

/// Use case for deleting a habit
class DeleteHabitUseCase {
  final IHabitWriter _habitWriter;

  DeleteHabitUseCase(this._habitWriter);

  Future<void> execute(HabitEntity habit) async {
    await _habitWriter.deleteHabit(habit);
  }
}
