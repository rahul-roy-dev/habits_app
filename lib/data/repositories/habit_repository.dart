import 'package:hive_flutter/hive_flutter.dart';
import 'package:habits_app/data/models/habit_model.dart';
import 'package:habits_app/abstracts/i_habit_repository.dart';

class HabitRepository implements IHabitRepository {
  static const String _habitBoxName = 'habitBox';

  @override
  Future<void> init() async {
    await Hive.openBox<HabitModel>(_habitBoxName);
  }

  Box<HabitModel> get _box => Hive.box<HabitModel>(_habitBoxName);

  @override
  Future<void> addHabit(HabitModel habit) async {
    await _box.add(habit);
  }

  @override
  List<HabitModel> getHabitsForUser(String userId) {
    return _box.values.where((habit) => habit.userId == userId).toList();
  }

  @override
  Future<void> updateHabit(dynamic key, HabitModel habit) async {
    await _box.put(key, habit);
  }

  @override
  Future<void> deleteHabit(HabitModel habit) async {
    await habit.delete();
  }

  @override
  Future<void> toggleHabitCompletion(HabitModel habit, DateTime date) async {
    final List<DateTime> newCompletionDates = List.from(habit.completionDates);
    final normalizedDate = DateTime(date.year, date.month, date.day);

    bool alreadyCompleted = newCompletionDates.any(
      (d) =>
          d.year == normalizedDate.year &&
          d.month == normalizedDate.month &&
          d.day == normalizedDate.day,
    );

    if (alreadyCompleted) {
      newCompletionDates.removeWhere(
        (d) =>
            d.year == normalizedDate.year &&
            d.month == normalizedDate.month &&
            d.day == normalizedDate.day,
      );
    } else {
      newCompletionDates.add(normalizedDate);
    }

    final updatedHabit = habit.copyWith(
      isCompleted: !alreadyCompleted,
      completionDates: newCompletionDates,
    );

    await _box.put(habit.key, updatedHabit);
  }
}
