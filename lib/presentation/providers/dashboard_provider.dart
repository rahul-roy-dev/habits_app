import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/domain/common/filter_habits_for_date.dart';
import 'package:habits_app/domain/common/habit_filter.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/presentation/providers/habit_provider.dart';

class DashboardSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => HabitEntity.normalizeDate(DateTime.now());

  void setDate(DateTime d) {
    state = HabitEntity.normalizeDate(d);
  }
}

/// Selected date on the dashboard (date strip, progress card, habit list).
final dashboardSelectedDateProvider =
    NotifierProvider<DashboardSelectedDateNotifier, DateTime>(
  DashboardSelectedDateNotifier.new,
);

/// Notifier for habit list filter (Ongoing / Completed).
class HabitFilterNotifier extends Notifier<HabitFilter> {
  @override
  HabitFilter build() => HabitFilter.ongoing;

  void setFilter(HabitFilter f) {
    state = f;
  }
}

final habitFilterProvider =
    NotifierProvider<HabitFilterNotifier, HabitFilter>(HabitFilterNotifier.new);

/// Notifier for habit list sort order (A-Z / Z-A by title).
class HabitSortOrderNotifier extends Notifier<HabitSortOrder> {
  @override
  HabitSortOrder build() => HabitSortOrder.aToZ;

  void setSortOrder(HabitSortOrder order) {
    state = order;
  }
}

final habitSortOrderProvider =
    NotifierProvider<HabitSortOrderNotifier, HabitSortOrder>(HabitSortOrderNotifier.new);

/// Habits that appear on the selected date (domain: [HabitEntity.appearsOnDate]).
final habitsForSelectedDateProvider = Provider<List<HabitEntity>>((ref) {
  final habits = ref.watch(habitProvider).habits;
  final selectedDate = ref.watch(dashboardSelectedDateProvider);
  final normalized = HabitEntity.normalizeDate(selectedDate);
  return habits.where((h) => h.appearsOnDate(normalized)).toList();
});

/// Habits filtered by [dashboardSelectedDateProvider] and [habitFilterProvider],
/// sorted per [habitSortOrderProvider]. Uses domain [filterHabitsForDate].
final filteredHabitsProvider = Provider<List<HabitEntity>>((ref) {
  final habitsForDate = ref.watch(habitsForSelectedDateProvider);
  final selectedDate = ref.watch(dashboardSelectedDateProvider);
  final filter = ref.watch(habitFilterProvider);
  final sortOrder = ref.watch(habitSortOrderProvider);
  return filterHabitsForDate(habitsForDate, selectedDate, filter, sortOrder);
});
