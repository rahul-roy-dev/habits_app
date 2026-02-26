import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'package:habits_app/domain/common/habit_filter.dart';

/// Reusable row of filter chips for Ongoing / Completed.
/// Receives current [filter] and [onFilterChanged]; no dependency on habit state.
class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  final HabitFilter filter;
  final ValueChanged<HabitFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _Chip(
          label: AppStrings.ongoing,
          isSelected: filter == HabitFilter.ongoing,
          isCompletedStyle: false,
          isDark: isDark,
          onTap: () => onFilterChanged(HabitFilter.ongoing),
        ),
        SizedBox(width: AppDimensions.spacingSm),
        _Chip(
          label: AppStrings.completed,
          isSelected: filter == HabitFilter.completed,
          isCompletedStyle: true,
          isDark: isDark,
          onTap: () => onFilterChanged(HabitFilter.completed),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.isCompletedStyle,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isCompletedStyle;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (isCompletedStyle
            ? (isDark ? AppColors.secondaryAccent : AppColors.lightSuccess)
            : (isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent))
        : (isDark ? AppColors.surface : AppColors.lightSurface);
    final textColor = isSelected
        ? AppColors.white
        : (isDark ? AppColors.secondaryText : AppColors.lightSecondaryText);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.chipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXs,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isSelected
              ? null
              : Border.all(
                  color: (isDark ? AppColors.secondaryText : AppColors.lightSecondaryText)
                      .withValues(alpha: AppDimensions.opacityMd),
                  width: AppDimensions.borderWidthThin,
                ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: AppDimensions.fontSizeSm,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
