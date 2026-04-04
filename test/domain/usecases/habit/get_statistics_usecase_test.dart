import 'package:flutter_test/flutter_test.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/usecases/habit/get_statistics_usecase.dart';

/// Unit tests for [GetStatisticsUseCase] (data processing).
/// Uses a fixed [referenceDate] so results are deterministic. Add tests for new stats or edge cases here.
void main() {
  late GetStatisticsUseCase useCase;
  late DateTime referenceDate;

  setUp(() {
    useCase = GetStatisticsUseCase();
    referenceDate = DateTime(2025, 3, 15); // Saturday, mid-March
  });

  group('GetStatisticsUseCase.execute', () {
    test('returns empty result for empty habits', () {
      final result = useCase.execute([], referenceDate);
      expect(result.monthlyCompletionPercent, 0.0);
      expect(result.bestStreakDays, 0);
      expect(result.topStreaksByCategory, isEmpty);
      expect(result.insightMessage, isNotEmpty);
    });

    test('computes best streak from consecutive completion dates across habits', () {
      final habit1 = HabitEntity(
        id: '1',
        title: 'Run',
        createdAt: referenceDate,
        userId: 'u1',
        completionDates: [
          DateTime(2025, 3, 10),
          DateTime(2025, 3, 11),
          DateTime(2025, 3, 12),
        ],
      );
      final habit2 = HabitEntity(
        id: '2',
        title: 'Read',
        createdAt: referenceDate,
        userId: 'u1',
        completionDates: [DateTime(2025, 3, 13)],
      );
      final result = useCase.execute([habit1, habit2], referenceDate);
      expect(result.bestStreakDays, 4); // 10,11,12,13 consecutive
    });

    test('monthly completion percent uses reference month and habit count', () {
      final marchOnly = DateTime(2025, 3, 15);
      final habit = HabitEntity(
        id: '1',
        title: 'One',
        createdAt: marchOnly,
        userId: 'u1',
        completionDates: [
          DateTime(2025, 3, 1),
          DateTime(2025, 3, 2),
        ],
      );
      final result = useCase.execute([habit], marchOnly);
      final daysInMarch = 31;
      final expectedPercent = (2 / daysInMarch) * 100.0;
      expect(result.monthlyCompletionPercent, closeTo(expectedPercent, 0.01));
    });

    test('top streaks by category are sorted by value descending', () {
      final low = HabitEntity(
        id: '1',
        title: 'Low',
        createdAt: referenceDate,
        userId: 'u1',
        completionDates: [DateTime(2025, 3, 1)],
      );
      final high = HabitEntity(
        id: '2',
        title: 'High',
        createdAt: referenceDate,
        userId: 'u1',
        completionDates: [
          DateTime(2025, 3, 1),
          DateTime(2025, 3, 2),
          DateTime(2025, 3, 3),
        ],
      );
      final result = useCase.execute([low, high], referenceDate);
      expect(result.topStreaksByCategory.length, 2);
      expect(result.topStreaksByCategory.first.title, 'HIGH');
      expect(result.topStreaksByCategory.first.valueDays, 3);
      expect(result.topStreaksByCategory.last.valueDays, 1);
    });
  });
}
