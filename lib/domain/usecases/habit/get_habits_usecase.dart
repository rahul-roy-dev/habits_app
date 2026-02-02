import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';

/// Use case for getting all habits for a user
class GetHabitsUseCase {
  final IHabitReader _habitReader;

  GetHabitsUseCase(this._habitReader);


  List<HabitEntity> execute(String userId) {
    return _habitReader.getHabitsForUser(userId);
  }
}
