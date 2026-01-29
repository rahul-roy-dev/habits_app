import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

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
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor:
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
                          .withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark
                        ? AppColors.primaryAccent
                        : AppColors.lightPrimaryAccent,
                  ),
                ),
              ),
              Icon(
                icon,
                color: isDark
                    ? AppColors.primaryAccent
                    : AppColors.lightPrimaryAccent,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: isDark
                  ? AppColors.primaryText
                  : AppColors.lightPrimaryText,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: isDark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
