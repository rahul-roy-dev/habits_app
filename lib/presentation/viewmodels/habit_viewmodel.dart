import 'package:flutter/material.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/usecases/habit/get_habits_usecase.dart';
import 'package:habits_app/domain/usecases/habit/add_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/update_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/delete_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/toggle_habit_usecase.dart';
import 'package:habits_app/domain/usecases/habit/get_habit_stats_usecase.dart';

/// ViewModel for managing habit-related UI state
/// Follows Clean Architecture by depending on Use Cases, not Repositories
class HabitViewModel extends ChangeNotifier {
  final GetHabitsUseCase _getHabitsUseCase;
  final AddHabitUseCase _addHabitUseCase;
  final UpdateHabitUseCase _updateHabitUseCase;
  final DeleteHabitUseCase _deleteHabitUseCase;
  final ToggleHabitUseCase _toggleHabitUseCase;
  final GetHabitStatsUseCase _getHabitStatsUseCase;

  HabitViewModel({
    required GetHabitsUseCase getHabitsUseCase,
    required AddHabitUseCase addHabitUseCase,
    required UpdateHabitUseCase updateHabitUseCase,
    required DeleteHabitUseCase deleteHabitUseCase,
    required ToggleHabitUseCase toggleHabitUseCase,
    required GetHabitStatsUseCase getHabitStatsUseCase,
  })  : _getHabitsUseCase = getHabitsUseCase,
        _addHabitUseCase = addHabitUseCase,
        _updateHabitUseCase = updateHabitUseCase,
        _deleteHabitUseCase = deleteHabitUseCase,
        _toggleHabitUseCase = toggleHabitUseCase,
        _getHabitStatsUseCase = getHabitStatsUseCase;

  List<HabitEntity> _habits = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<HabitEntity> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits(String userId) async {
    _isLoading = true;
    _currentUserId = userId;
    notifyListeners();

    _habits = _getHabitsUseCase.execute(userId);

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
    await _addHabitUseCase.execute(
      title: title,
      description: description,
      icon: icon,
      color: color,
      userId: userId,
    );
    await loadHabits(userId);
  }

  Future<void> updateHabit(String habitId, HabitEntity habit) async {
    await _updateHabitUseCase.execute(habitId, habit);
    await loadHabits(habit.userId);
  }

  Future<void> toggleHabit(HabitEntity habit, DateTime date) async {
    await _toggleHabitUseCase.execute(habit, date);
    await loadHabits(habit.userId);
  }

  Future<void> deleteHabit(HabitEntity habit) async {
    final userId = habit.userId;
    await _deleteHabitUseCase.execute(habit);
    await loadHabits(userId);
  }

  // Statistics - delegated to use case
  int get totalHabits => _currentUserId != null 
      ? _getHabitStatsUseCase.getTotalHabits(_currentUserId!) 
      : 0;

  double getCompletionProgress(DateTime date) {
    if (_currentUserId == null) return 0.0;
    return _getHabitStatsUseCase.getCompletionProgress(_currentUserId!, date);
  }

  int getCompletedCount(DateTime date) {
    if (_currentUserId == null) return 0;
    return _getHabitStatsUseCase.getCompletedCount(_currentUserId!, date);
  }
}
