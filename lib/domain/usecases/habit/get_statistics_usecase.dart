import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/entities/statistics_result.dart';

/// Computes statistics from a list of habits (e.g. from [habitProvider]).
/// No I/O; pure computation so it can be run synchronously in a provider.
class GetStatisticsUseCase {
  static const List<String> _monthAbbr = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static const int _daysPerWeek = 7;
  static const int _daysFromMondayToSunday = _daysPerWeek - 1;
  static const int _streakProgressCapDays = 30;
  static const double _streakProgressMin = 0.12;
  static const int _monthsPerYear = 12;
  /// Number of months shown in consistency chart (current year + Jan next year).
  static const int _consistencyMonthCount = 13;
  /// Lookback days for insight message (e.g. "most consistent on Monday").
  static const int _insightLookbackDays = 14;

  StatisticsResult execute(List<HabitEntity> habits, [DateTime? referenceDate]) {
    if (habits.isEmpty) return StatisticsResult.empty();

    final now = referenceDate ?? DateTime.now();
    final totalHabits = habits.length;

    final monthlyPercent = _monthlyCompletionPercent(habits, now, totalHabits);
    final bestStreak = _bestStreakDays(habits);
    final (heatmapValues, heatmapRange) = _heatmapForCurrentWeek(habits, now);
    final topStreaks = _topStreaksByHabit(habits, bestStreak);
    final (barHeightsWeek, weekDayLabels) =
        _consistencyBarHeightsWeekWithLabels(habits, now, totalHabits);
    final (barHeightsMonth, monthLabels) =
        _consistencyBarHeightsMonthWithLabels(habits, now, totalHabits);
    final insight = _insightMessage(habits, now);

    return StatisticsResult(
      monthlyCompletionPercent: monthlyPercent,
      bestStreakDays: bestStreak,
      heatmapWeekdayValues: heatmapValues,
      heatmapDateRangeText: heatmapRange,
      topStreaksByCategory: topStreaks,
      consistencyBarHeightsWeek: barHeightsWeek,
      consistencyBarHeightsMonth: barHeightsMonth,
      consistencyWeekDayLabels: weekDayLabels,
      consistencyMonthLabels: monthLabels,
      insightMessage: insight,
    );
  }

  double _monthlyCompletionPercent(
    List<HabitEntity> habits,
    DateTime now,
    int totalHabits,
  ) {
    final year = now.year;
    final month = now.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    if (daysInMonth == 0) return 0.0;

    double sum = 0.0;
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final completed = habits.where((h) => h.isCompletedOnDate(date)).length;
      sum += totalHabits > 0 ? completed / totalHabits : 0.0;
    }
    return (sum / daysInMonth) * 100.0;
  }

  int _bestStreakDays(List<HabitEntity> habits) {
    final allDates = <DateTime>{};
    for (final h in habits) {
      for (final d in h.completionDates) {
        allDates.add(DateTime(d.year, d.month, d.day));
      }
    }
    if (allDates.isEmpty) return 0;
    final sorted = allDates.toList()..sort();
    var maxRun = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      final prev = sorted[i - 1];
      final cur = sorted[i];
      final diffDays = cur.difference(prev).inDays;
      if (diffDays == 1) {
        run++;
        if (run > maxRun) maxRun = run;
      } else {
        run = 1;
      }
    }
    return maxRun;
  }

  (List<double>, String) _heatmapForCurrentWeek(
    List<HabitEntity> habits,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final daysFromMonday = today.weekday - 1;
    final currentMonday = today.subtract(Duration(days: daysFromMonday));
    final currentSunday =
        currentMonday.add(const Duration(days: _daysFromMondayToSunday));

    final values = List<double>.filled(_daysPerWeek, 0.0);
    var maxCount = 0.0;
    for (var i = 0; i < _daysPerWeek; i++) {
      final date = currentMonday.add(Duration(days: i));
      final count = habits.where((h) => h.isCompletedOnDate(date)).length;
      values[i] = count.toDouble();
      if (count > maxCount) maxCount = count.toDouble();
    }
    final normalized = maxCount > 0
        ? values.map((v) => v / maxCount).toList()
        : List<double>.filled(_daysPerWeek, 0.0);

    final startStr =
        '${_monthAbbr[currentMonday.month - 1]} ${currentMonday.day}';
    final endStr =
        '${_monthAbbr[currentSunday.month - 1]} ${currentSunday.day}';
    final rangeText = '$startStr - $endStr';

    return (normalized, rangeText);
  }

  List<TopStreakEntry> _topStreaksByHabit(
    List<HabitEntity> habits,
    int globalMaxStreak,
  ) {
    final entries = <TopStreakEntry>[];
    final maxForProgress = (globalMaxStreak < _streakProgressCapDays)
        ? _streakProgressCapDays
        : globalMaxStreak;

    for (final h in habits) {
      final dates = <DateTime>{};
      for (final d in h.completionDates) {
        dates.add(DateTime(d.year, d.month, d.day));
      }
      final streak = _longestConsecutive(dates);

      final title = h.title;
      final rawProgress = streak / maxForProgress;
      final progress = _streakProgressMin +
          (1.0 - _streakProgressMin) * (rawProgress > 1.0 ? 1.0 : rawProgress);
      entries.add(TopStreakEntry(
        title: title.toUpperCase(),
        valueDays: streak,
        progress: progress,
        iconKey: h.icon,
      ));
    }

    entries.sort((a, b) => b.valueDays.compareTo(a.valueDays));
    return entries;
  }

  int _longestConsecutive(Set<DateTime> dates) {
    if (dates.isEmpty) return 0;
    final sorted = dates.toList()..sort();
    var maxRun = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      final diff = sorted[i].difference(sorted[i - 1]).inDays;
      if (diff == 1) {
        run++;
        if (run > maxRun) maxRun = run;
      } else {
        run = 1;
      }
    }
    return maxRun;
  }

  static const List<String> _weekDayAbbr = [
    'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN',
  ];

  /// Last 7 days (oldest to newest) with labels for each bar's weekday.
  (List<int>, List<String>) _consistencyBarHeightsWeekWithLabels(
    List<HabitEntity> habits,
    DateTime now,
    int totalHabits,
  ) {
    final heights = <int>[];
    final labels = <String>[];
    final today = DateTime(now.year, now.month, now.day);
    for (var i = _daysFromMondayToSunday; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final completed =
          habits.where((h) => h.isCompletedOnDate(date)).length;
      final rate = totalHabits > 0 ? completed / totalHabits : 0.0;
      heights.add((rate * 100).round().clamp(0, 100));
      labels.add(_weekDayAbbr[date.weekday - 1]);
    }
    return (heights, labels);
  }

  /// Current year Jan–Dec + January next year (13 months).
  (List<int>, List<String>) _consistencyBarHeightsMonthWithLabels(
    List<HabitEntity> habits,
    DateTime now,
    int totalHabits,
  ) {
    final heights = <int>[];
    final labels = <String>[];
    for (var i = 0; i < _consistencyMonthCount; i++) {
      final year = now.year + (i ~/ _monthsPerYear);
      final month = (i % _monthsPerYear) + 1;
      final daysInMonth = DateTime(year, month + 1, 0).day;
      double sum = 0.0;
      for (var d = 1; d <= daysInMonth; d++) {
        final date = DateTime(year, month, d);
        final completed =
            habits.where((h) => h.isCompletedOnDate(date)).length;
        sum += totalHabits > 0 ? completed / totalHabits : 0.0;
      }
      final avg = daysInMonth > 0 ? (sum / daysInMonth) * 100 : 0.0;
      heights.add(avg.round().clamp(0, 100));
      labels.add(_monthAbbr[month - 1]);
    }
    return (heights, labels);
  }

  String _insightMessage(List<HabitEntity> habits, DateTime now) {
    final weekdayCounts = List.filled(_daysPerWeek, 0);
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: _insightLookbackDays));
    for (var i = 0; i < _insightLookbackDays; i++) {
      final date = start.add(Duration(days: i));
      final completed = habits.where((h) => h.isCompletedOnDate(date)).length;
      if (completed > 0) {
        weekdayCounts[date.weekday - 1] += completed;
      }
    }
    var bestWeekday = 0;
    var bestCount = 0;
    for (var w = 0; w < _daysPerWeek; w++) {
      if (weekdayCounts[w] > bestCount) {
        bestCount = weekdayCounts[w];
        bestWeekday = w;
      }
    }
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (bestCount > 0) {
      return "You're most consistent on ${names[bestWeekday]}.";
    }
    return 'Complete habits to see your consistency insights.';
  }
}
