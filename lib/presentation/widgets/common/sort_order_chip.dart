import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'package:habits_app/domain/common/habit_filter.dart';

///  Sort Order dropdown for sort order (A-Z or Z-A by habit title).
class SortOrderDropdown extends StatelessWidget {
  const SortOrderDropdown({
    super.key,
    required this.sortOrder,
    required this.onChanged,
  });

  final HabitSortOrder sortOrder;
  final ValueChanged<HabitSortOrder?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = (isDark ? AppColors.secondaryText : AppColors.lightSecondaryText)
        .withValues(alpha: AppDimensions.opacityMd);

    return Container(
      height: AppDimensions.chipHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXs,
      ),
      constraints: const BoxConstraints(
        minWidth: AppDimensions.sortChipMinWidth,
        maxWidth: AppDimensions.sortChipMaxWidth,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: borderColor,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<HabitSortOrder>(
          value: sortOrder,
          isDense: true,
          isExpanded: true,
          icon: const SizedBox.shrink(),
          dropdownColor: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          elevation: AppDimensions.elevationMd.toInt(),
          onChanged: onChanged,
          items: const [
            DropdownMenuItem(
              value: HabitSortOrder.aToZ,
              child: Text(AppStrings.sortAZ),
            ),
            DropdownMenuItem(
              value: HabitSortOrder.zToA,
              child: Text(AppStrings.sortZA),
            ),
          ],
          selectedItemBuilder: (context) => [
            Center(
              child: Text(
                AppStrings.sortAZ,
                style: TextStyle(
                  color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Center(
              child: Text(
                AppStrings.sortZA,
                style: TextStyle(
                  color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
                  fontSize: AppDimensions.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
