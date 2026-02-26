import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';

/// Use case for adding a new habit
class AddHabitUseCase {
  final IHabitWriter _habitWriter;

  AddHabitUseCase(this._habitWriter);


  Future<void> execute({
    required String title,
    required String description,
    required String icon,
    required int color,
    required String userId,
    List<int> selectedWeekdays = const [],
  }) async {
    final newHabit = HabitEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      icon: icon,
      color: color,
      userId: userId,
      selectedWeekdays: selectedWeekdays,
    );

    await _habitWriter.addHabit(newHabit);
  }
}
