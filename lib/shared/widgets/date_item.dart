import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habits_app/core/theme/app_colors.dart';

class DateItem extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const DateItem({super.key, required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isToday
            ? (isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent)
            : (isDark ? AppColors.surface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color:
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
                          .withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date.day.toString(),
            style: TextStyle(
              color: isToday
                  ? AppColors.white
                  : (isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isToday)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
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
