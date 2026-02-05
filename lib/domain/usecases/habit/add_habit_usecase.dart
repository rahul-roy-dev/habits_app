import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';
import 'package:habits_app/domain/usecases/habit/add_habit_params.dart';

/// Use case for adding a new habit
class AddHabitUseCase extends BaseUseCase<void, AddHabitParams> {
  final IHabitWriter _habitWriter;

  AddHabitUseCase(this._habitWriter);

  @override
  Future<void> call(AddHabitParams params) async {
    params.validate();

    final newHabit = HabitEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: params.title.trim(),
      description: params.description.trim(),
      createdAt: DateTime.now(),
      icon: params.icon,
      color: params.color,
      userId: params.userId,
    );

    try {
      await _habitWriter.addHabit(newHabit);
    } catch (e) {
      throw Exception('Failed to add habit: ${e.toString()}');
    }
  }

  Future<void> execute({
    required String title,
    required String description,
    required String icon,
    required int color,
    required String userId,
  }) async {
    final params = AddHabitParams(
      title: title,
      description: description,
      icon: icon,
      color: color,
      userId: userId,
    );
    await call(params);
  }
}
