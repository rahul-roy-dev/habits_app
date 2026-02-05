import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'dependency_providers.dart';
import 'auth_provider.dart';

part 'habit_provider.g.dart';

class HabitState {
  final List<HabitEntity> habits;
  final bool isLoading;

  const HabitState({
    this.habits = const [],
    this.isLoading = false,
  });

  HabitState copyWith({
    List<HabitEntity>? habits,
    bool? isLoading,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class Habit extends _$Habit {
  @override
  HabitState build() {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    
    if (user == null) {
      return const HabitState();
    }
    
    ref.listen(authProvider, (_, next) {
      if (next.currentUser != user) {
        if (next.currentUser != null) {
          loadHabits();
        } else {
          state = const HabitState();
        }
      }
    });
    
    state = const HabitState(isLoading: true);
    
    Future.microtask(() async {
      await ref.read(loadingDelayUseCaseProvider).execute();
      
      try {
        final habits = ref.read(getHabitsUseCaseProvider).execute(user.id);
        state = HabitState(habits: habits, isLoading: false);
      } catch (_) {
        state = const HabitState(isLoading: false);
      }
    });
    
    return const HabitState(isLoading: true);
  }

  Future<void> loadHabits() async {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    state = state.copyWith(isLoading: true);
    
    await ref.read(loadingDelayUseCaseProvider).execute();

    try {
      final habits = ref.read(getHabitsUseCaseProvider).execute(user.id);
      state = state.copyWith(habits: habits, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _refreshHabitsWithoutDelay() async {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    try {
      final habits = ref.read(getHabitsUseCaseProvider).execute(user.id);
      state = state.copyWith(habits: habits);
    } catch (e) {
      // Handle error silently for background refresh
    }
  }

  Future<void> addHabit(
    String title,
    String description,
    String icon,
    int color,
  ) async {
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    await ref.read(addHabitUseCaseProvider).execute(
      title: title,
      description: description,
      icon: icon,
      color: color,
      userId: user.id,
    );
    await _refreshHabitsWithoutDelay();
  }

  Future<void> updateHabit(String habitId, HabitEntity habit) async {
    await ref.read(updateHabitUseCaseProvider).execute(habitId, habit);
    await _refreshHabitsWithoutDelay();
  }

  Future<void> toggleHabit(HabitEntity habit, DateTime date) async {
    await ref.read(toggleHabitUseCaseProvider).execute(habit, date);
    await _refreshHabitsWithoutDelay();
  }

  Future<void> deleteHabit(HabitEntity habit) async {
    await ref.read(deleteHabitUseCaseProvider).execute(habit);
    await _refreshHabitsWithoutDelay();
  }
}

@riverpod
int totalHabits(Ref ref) {
  return ref.watch(habitProvider).habits.length;
}

@riverpod
double habitCompletionProgress(Ref ref, DateTime date) {
  final habits = ref.watch(habitProvider).habits;
  if (habits.isEmpty) return 0.0;

  int completedCount = 0;
  for (var habit in habits) {
    bool isCompletedOnDate = habit.completionDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
    if (isCompletedOnDate) completedCount++;
  }

  return completedCount / habits.length;
}

@riverpod
bool isHabitCompleted(Ref ref, {required HabitEntity habit, required DateTime date}) {
  return habit.completionDates.any(
    (d) => d.year == date.year && d.month == date.month && d.day == date.day,
  );
}

@riverpod
int completedHabitsCount(Ref ref, DateTime date) {
  final habits = ref.watch(habitProvider).habits;
  return habits.where((habit) {
    return habit.completionDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }).length;
}
