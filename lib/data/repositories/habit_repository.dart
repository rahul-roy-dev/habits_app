import 'package:hive_flutter/hive_flutter.dart';
import 'package:habits_app/data/models/habit_model.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/i_habit_repository.dart';
import 'package:habits_app/core/constants/app_values.dart';

class HabitRepository implements IHabitRepository {
  @override
  Future<void> init() async {
    await Hive.openBox<HabitModel>(AppValues.habitBoxName);
  }

  Box<HabitModel> get _box => Hive.box<HabitModel>(AppValues.habitBoxName);

  // Convert HabitModel to HabitEntity
  HabitEntity _toEntity(HabitModel model) {
    return HabitEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      createdAt: model.createdAt,
      icon: model.icon,
      color: model.color,
      completionDates: model.completionDates,
      userId: model.userId,
    );
  }

  // Convert HabitEntity to HabitModel
  HabitModel _toModel(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      icon: entity.icon,
      color: entity.color,
      completionDates: entity.completionDates,
      userId: entity.userId,
    );
  }

  @override
  Future<void> addHabit(HabitEntity habit) async {
    await _box.add(_toModel(habit));
  }

  @override
  List<HabitEntity> getHabitsForUser(String userId) {
    return _box.values
        .where((habit) => habit.userId == userId)
        .map((model) => _toEntity(model))
        .toList();
  }

  @override
  Future<void> updateHabit(String habitId, HabitEntity habit) async {
    final model = _box.values.firstWhere((m) => m.id == habitId);
    await _box.put(model.key, _toModel(habit));
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    final model = _box.values.firstWhere((m) => m.id == habit.id);
    await model.delete();
  }

  @override
  Future<void> toggleHabitCompletion(HabitEntity habit, DateTime date) async {
    final model = _box.values.firstWhere((m) => m.id == habit.id);
    final List<DateTime> newCompletionDates = List.from(model.completionDates);
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

    final updatedModel = model.copyWith(
      isCompleted: !alreadyCompleted,
      completionDates: newCompletionDates,
    );

    await _box.put(model.key, updatedModel);
  }
}
