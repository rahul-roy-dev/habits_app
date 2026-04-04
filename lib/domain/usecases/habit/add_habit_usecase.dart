import 'package:habits_app/core/constants/app_values.dart';
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
    int? alertHour,
    int? alertMinute,
    HabitEndMode endMode = HabitEndMode.none,
    DateTime? endOnDate,
    int? endAfterDaysCount,
  }) async {
    final createdAt = DateTime.now();
    final resolved = HabitEntity.resolveEndFields(
      endMode: endMode,
      anchorCreatedAt: createdAt,
      pickedEndDate: endOnDate,
      durationDays: endAfterDaysCount,
      minDays: AppValues.habitEndDaysMin,
      maxDays: AppValues.habitEndDaysMax,
      defaultDays: AppValues.habitEndDaysDefault,
    );
    final newHabit = HabitEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: createdAt,
      icon: icon,
      color: color,
      userId: userId,
      selectedWeekdays: selectedWeekdays,
      alertHour: alertHour,
      alertMinute: alertMinute,
      endMode: resolved.mode,
      endDate: resolved.endDate,
      endAfterDays: resolved.endAfterDays,
    );

    await _habitWriter.addHabit(newHabit);
  }
}
