import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

/// Reusable pill badge for status labels (e.g. Ongoing, Completed).
/// [isCompleted] true uses success/accent styling; false uses muted secondary.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.isCompleted,
  });

  final String label;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isCompleted
        ? (isDark ? AppColors.secondaryAccent : AppColors.lightSuccess)
        : (isDark
            ? AppColors.surface
            : AppColors.lightInputBackground);
    final textColor = isCompleted
        ? AppColors.white
        : (isDark
            ? AppColors.secondaryText
            : AppColors.lightSecondaryText);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: AppDimensions.fontSizeSm,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
