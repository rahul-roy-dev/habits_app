import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  const DateItem({
    super.key,
    required this.date,
    required this.isToday,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final highlighted = isSelected || isToday;
    final color = highlighted
        ? (isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent)
        : (isDark ? AppColors.surface : AppColors.lightSurface);
    final textColor = highlighted
        ? AppColors.white
        : (isDark ? AppColors.primaryText : AppColors.lightPrimaryText);
    final secondaryTextColor = highlighted
        ? AppColors.white
        : (isDark ? AppColors.secondaryText : AppColors.lightSecondaryText);

    final content = Container(
      width: AppDimensions.dateItemWidth,
      margin: const EdgeInsets.only(right: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.dateItemRadius),
        boxShadow: highlighted
            ? [
                BoxShadow(
                  color: (isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent)
                      .withValues(alpha: AppDimensions.opacityMd),
                  blurRadius: AppDimensions.shadowBlurSm,
                  offset: const Offset(0, AppDimensions.shadowOffsetY),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date).toUpperCase(),
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: AppDimensions.fontSizeXxs,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spacingXxs),
          Text(
            date.day.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: AppDimensions.fontSizeXxl,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isToday)
            Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacingXxs),
              width: AppDimensions.dateDotSize,
              height: AppDimensions.dateDotSize,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}
