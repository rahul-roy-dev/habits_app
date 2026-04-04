import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/theme/app_shadows.dart';

class StreakCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final IconData icon;

  const StreakCard({
    super.key,
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surface : AppColors.lightSurface;
    return Container(
      width: AppDimensions.streakCardWidth,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.cardDrop(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: AppDimensions.streakProgressSize,
                  height: AppDimensions.streakProgressSize,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: AppDimensions.streakProgressStrokeWidth,
                    backgroundColor:
                        (isDark
                                ? AppColors.primaryAccent
                                : AppColors.lightPrimaryAccent)
                            .withValues(alpha: AppDimensions.streakProgressOpacityIncomplete),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
                          .withValues(alpha: AppDimensions.streakProgressOpacityComplete),
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: isDark
                      ? AppColors.primaryAccent
                      : AppColors.lightPrimaryAccent,
                  size: AppDimensions.iconSizeSm,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              value,
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
                fontWeight: FontWeight.bold,
                fontSize: AppDimensions.fontSizeXxxl,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: isDark
                    ? AppColors.secondaryText
                    : AppColors.lightSecondaryText,
                fontSize: AppDimensions.fontSizeStreakTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
