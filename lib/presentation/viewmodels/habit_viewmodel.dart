import 'package:flutter/material.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/i_habit_repository.dart';

class HabitViewModel extends ChangeNotifier {
  final IHabitRepository _habitRepository;

  HabitViewModel({required IHabitRepository repository})
    : _habitRepository = repository;

  List<HabitEntity> _habits = [];
  bool _isLoading = false;

  List<HabitEntity> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits(String userId) async {
    _isLoading = true;
    notifyListeners();

    _habits = _habitRepository.getHabitsForUser(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(
    String title,
    String description,
    String icon,
    int color,
    String userId,
  ) async {
    final newHabit = HabitEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      icon: icon,
      color: color,
      userId: userId,
    );

    await _habitRepository.addHabit(newHabit);
    await loadHabits(userId);
  }

  Future<void> updateHabit(String habitId, HabitEntity habit) async {
    await _habitRepository.updateHabit(habitId, habit);
    await loadHabits(habit.userId);
  }

  Future<void> toggleHabit(HabitEntity habit, DateTime date) async {
    await _habitRepository.toggleHabitCompletion(habit, date);
    await loadHabits(habit.userId);
  }

  Future<void> deleteHabit(HabitEntity habit) async {
    final userId = habit.userId;
    await _habitRepository.deleteHabit(habit);
    await loadHabits(userId);
  }

  int get totalHabits => _habits.length;

  double getCompletionProgress(DateTime date) {
    if (_habits.isEmpty) return 0.0;

    int completedCount = 0;
    for (var habit in _habits) {
      bool isCompletedOnDate = habit.completionDates.any(
        (d) =>
            d.year == date.year && d.month == date.month && d.day == date.day,
      );
      if (isCompletedOnDate) completedCount++;
    }

    return completedCount / _habits.length;
  }

  int getCompletedCount(DateTime date) {
    return _habits
        .where(
          (habit) => habit.completionDates.any(
            (d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day,
          ),
        )
        .length;
  }
}
