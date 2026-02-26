import 'package:habits_app/domain/common/habit_filter.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';

/// Domain logic: filter habits that appear on [date] by [filter] (ongoing/completed)
/// and sort by title according to [sortOrder].
List<HabitEntity> filterHabitsForDate(
  List<HabitEntity> habits,
  DateTime date,
  HabitFilter filter,
  HabitSortOrder sortOrder,
) {
  final normalized = HabitEntity.normalizeDate(date);
  final forDate = habits.where((h) => h.appearsOnDate(normalized)).toList();

  List<HabitEntity> list;
  switch (filter) {
    case HabitFilter.ongoing:
      list = forDate.where((h) => !h.isCompletedOnDate(normalized)).toList();
      break;
    case HabitFilter.completed:
      list = forDate.where((h) => h.isCompletedOnDate(normalized)).toList();
      break;
  }

  list = List<HabitEntity>.from(list)
    ..sort((a, b) {
      final cmp = a.title.compareTo(b.title);
      return sortOrder == HabitSortOrder.aToZ ? cmp : -cmp;
    });
  return list;
}
