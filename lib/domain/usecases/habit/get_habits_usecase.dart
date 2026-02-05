import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for get habits use case
class GetHabitsParams {
  final String userId;

  const GetHabitsParams({required this.userId});
}

/// Use case for getting all habits for a user
class GetHabitsUseCase extends BaseUseCase<List<HabitEntity>, GetHabitsParams> {
  final IHabitReader _habitReader;

  GetHabitsUseCase(this._habitReader);

  @override
  Future<List<HabitEntity>> call(GetHabitsParams params) async {
    return _habitReader.getHabitsForUser(params.userId);
  }

  List<HabitEntity> execute(String userId) {
    return _habitReader.getHabitsForUser(userId);
  }
}
