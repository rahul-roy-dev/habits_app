import 'package:flutter_test/flutter_test.dart';
import 'package:habits_app/domain/common/filter_habits_for_date.dart';
import 'package:habits_app/domain/common/habit_filter.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';

/// Unit tests for [filterHabitsForDate] (filter + sort for dashboard).
/// Mirrors lib/domain/common/ so other devs can add tests under test/domain/common/ for new domain logic.
void main() {
  late DateTime monday;
  late HabitEntity dailyHabit;
  late HabitEntity weeklyHabitMonWed;
  late HabitEntity completedOnMonday;

  setUp(() {
    monday = DateTime(2025, 3, 10); // Monday
    dailyHabit = HabitEntity(
      id: '1',
      title: 'Alpha',
      createdAt: monday,
      userId: 'u1',
      selectedWeekdays: [], // daily
      completionDates: [],
    );
    weeklyHabitMonWed = HabitEntity(
      id: '2',
      title: 'Beta',
      createdAt: monday,
      userId: 'u1',
      selectedWeekdays: [1, 3], // Mon, Wed
      completionDates: [],
    );
    completedOnMonday = HabitEntity(
      id: '3',
      title: 'Gamma',
      createdAt: monday,
      userId: 'u1',
      selectedWeekdays: [],
      completionDates: [DateTime(2025, 3, 10)],
    );
  });

  group('filterHabitsForDate', () {
    test('filters to habits that appear on date (daily vs weekly)', () {
      final habits = [dailyHabit, weeklyHabitMonWed];
      final wednesday = DateTime(2025, 3, 12);

      final mondayResult = filterHabitsForDate(habits, monday, HabitFilter.ongoing, HabitSortOrder.aToZ);
      final wednesdayResult = filterHabitsForDate(habits, wednesday, HabitFilter.ongoing, HabitSortOrder.aToZ);

      expect(mondayResult.length, 2);
      expect(wednesdayResult.length, 2);
      // Wednesday: weekly habit also appears (weekday 3)
      expect(wednesdayResult.any((h) => h.id == '2'), isTrue);

      final saturday = DateTime(2025, 3, 15);
      final saturdayResult = filterHabitsForDate(habits, saturday, HabitFilter.ongoing, HabitSortOrder.aToZ);
      expect(saturdayResult.length, 1); // only daily
      expect(saturdayResult.single.id, '1');
    });

    test('ongoing filter excludes completed-on-date habits', () {
      final habits = [dailyHabit, completedOnMonday];
      final result = filterHabitsForDate(habits, monday, HabitFilter.ongoing, HabitSortOrder.aToZ);
      expect(result.length, 1);
      expect(result.single.id, '1');
    });

    test('completed filter returns only completed-on-date habits', () {
      final habits = [dailyHabit, completedOnMonday];
      final result = filterHabitsForDate(habits, monday, HabitFilter.completed, HabitSortOrder.aToZ);
      expect(result.length, 1);
      expect(result.single.id, '3');
    });

    test('sort order aToZ sorts by title ascending', () {
      final habits = [dailyHabit, weeklyHabitMonWed, completedOnMonday];
      final result = filterHabitsForDate(habits, monday, HabitFilter.ongoing, HabitSortOrder.aToZ);
      expect(result.map((h) => h.title).toList(), ['Alpha', 'Beta']);
    });

    test('sort order zToA sorts by title descending', () {
      final habits = [dailyHabit, weeklyHabitMonWed];
      final result = filterHabitsForDate(habits, monday, HabitFilter.ongoing, HabitSortOrder.zToA);
      expect(result.map((h) => h.title).toList(), ['Beta', 'Alpha']);
    });

    test('uses normalized date (time component ignored)', () {
      final habits = [completedOnMonday];
      final mondayEvening = DateTime(2025, 3, 10, 23, 59, 59);
      final result = filterHabitsForDate(habits, mondayEvening, HabitFilter.completed, HabitSortOrder.aToZ);
      expect(result.length, 1);
      expect(result.single.id, '3');
    });
  });
}
