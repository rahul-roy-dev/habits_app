import 'package:flutter/material.dart';

class DemoConstants {
  DemoConstants._();

  // Mini cards (top row)
  static const String monthlyCompletionValue = '84%';
  static const String bestStreakValue = '24 Days';

  // Heatmap
  static const String heatmapDateRange = 'OCT 14 - OCT 20';

  // Top streaks (horizontal list)
  static const String streak1Title = 'MORNING YOGA';
  static const String streak1Value = '12 Days';
  static const double streak1Progress = 0.7;
  static const IconData streak1Icon = Icons.wb_sunny_outlined;

  static const String streak2Title = 'HYDRATION';
  static const String streak2Value = '8 Days';
  static const double streak2Progress = 0.4;
  static const IconData streak2Icon = Icons.local_drink;

  static const String streak3Title = 'READING';
  static const String streak3Value = '15 Days';
  static const double streak3Progress = 0.9;
  static const IconData streak3Icon = Icons.menu_book;

  // Consistency chart bar heights (relative values)
  static const List<int> chartBarHeights = [60, 80, 70, 100, 75, 85, 40, 90, 100];
  static const double chartBarHeightMultiplier = 1.5;
  static const int chartBarHighOpacityThreshold = 80;

  // Insight card
  static const String insightTitle = 'Consistency Insight';
  static const String insightMessage =
      "You're most productive during early hours. Try setting your high-effort habits before 9 AM for a 30% higher success rate.";
}
