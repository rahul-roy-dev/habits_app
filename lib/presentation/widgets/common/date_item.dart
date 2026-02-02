import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const DateItem({super.key, required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: AppDimensions.dateItemWidth,
      margin: const EdgeInsets.only(right: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: isToday
            ? (isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent)
            : (isDark ? AppColors.surface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(AppDimensions.dateItemRadius),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color:
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
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
              color: isToday
                  ? AppColors.white
                  : (isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText),
              fontSize: AppDimensions.fontSizeXxs,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spacingXxs),
          Text(
            date.day.toString(),
            style: TextStyle(
              color: isToday
                  ? AppColors.white
                  : (isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText),
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
  }
}
