/// Result of statistics computation from habit data.
class StatisticsResult {
  final double monthlyCompletionPercent;
  final int bestStreakDays;
  final List<double> heatmapWeekdayValues;
  final String heatmapDateRangeText;
  final List<TopStreakEntry> topStreaksByCategory;
  final List<int> consistencyBarHeightsWeek;
  final List<int> consistencyBarHeightsMonth;
  final List<String> consistencyWeekDayLabels;
  /// Month view: JAN, FEB, … DEC (current year).
  final List<String> consistencyMonthLabels;
  final String insightMessage;

  const StatisticsResult({
    required this.monthlyCompletionPercent,
    required this.bestStreakDays,
    required this.heatmapWeekdayValues,
    required this.heatmapDateRangeText,
    required this.topStreaksByCategory,
    required this.consistencyBarHeightsWeek,
    required this.consistencyBarHeightsMonth,
    required this.consistencyWeekDayLabels,
    required this.consistencyMonthLabels,
    required this.insightMessage,
  });

  static const List<String> _emptyMonthLabels = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    'JAN', // next year January (13th item)
  ];

  factory StatisticsResult.empty() {
    return StatisticsResult(
      monthlyCompletionPercent: 0.0,
      bestStreakDays: 0,
      heatmapWeekdayValues: List.filled(7, 0.0),
      heatmapDateRangeText: '',
      topStreaksByCategory: const [],
      consistencyBarHeightsWeek: List.filled(7, 0),
      consistencyBarHeightsMonth: List.filled(13, 0),
      consistencyWeekDayLabels: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
      consistencyMonthLabels: _emptyMonthLabels,
      insightMessage: 'Complete habits to see your consistency insights.',
    );
  }
}

/// One entry for the Top Streaks list (by habit).
class TopStreakEntry {
  final String title;
  final int valueDays;
  final double progress;
  /// Habit icon key; resolve to IconData via [AppValues.habitIconMap].
  final String iconKey;

  const TopStreakEntry({
    required this.title,
    required this.valueDays,
    required this.progress,
    required this.iconKey,
  });
}
