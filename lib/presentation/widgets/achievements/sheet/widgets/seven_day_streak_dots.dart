import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheet_colors.dart';

class SevenDayStreakDots extends StatelessWidget {
  const SevenDayStreakDots({super.key});

  static const int _dayCount = 7;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_dayCount, (i) {
        final isLast = i == _dayCount - 1;
        return Padding(
          padding: EdgeInsets.only(
            left: i == 0 ? 0 : AchievementSheetDimensions.dayStreakDotGap,
          ),
          child: _DayDot(isLast: isLast),
        );
      }),
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    if (isLast) {
      return Container(
        width: AchievementSheetDimensions.streakDotCurrent,
        height: AchievementSheetDimensions.streakDotCurrent,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AchievementSheetColors.streakOrange,
          boxShadow: [
            BoxShadow(
              color: AchievementSheetColors.streakOrange
                  .withValues(alpha: AchievementSheetDimensions.streakDotFlameShadowAlpha),
              blurRadius: AchievementSheetDimensions.streakDotFlameBlur,
              spreadRadius: AchievementSheetDimensions.streakDotFlameSpread,
            ),
          ],
          border: Border.all(
            color: AchievementSheetColors.streakOrange
                .withValues(alpha: AchievementSheetDimensions.streakDotBorderAlpha),
            width: AchievementSheetDimensions.streakDotBorderWidth,
          ),
        ),
        child: Icon(
          LucideIcons.flame,
          color: Colors.white,
          size: AchievementSheetDimensions.streakDotFlameIcon,
        ),
      );
    }
    return Container(
      width: AchievementSheetDimensions.streakDotCompleted,
      height: AchievementSheetDimensions.streakDotCompleted,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AchievementSheetColors.successGreen,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: AchievementSheetDimensions.streakDotCheckIcon,
      ),
    );
  }
}
