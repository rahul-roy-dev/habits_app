import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/shared/widgets/custom_card.dart';

class StatMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isPercentage;

  const StatMiniCard({
    super.key,
    required this.title,
    required this.value,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.split('%')[0].split(' ')[0],
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPercentage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 2),
                  child: Text(
                    '%',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryAccent
                          : AppColors.lightPrimaryAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (value.contains('Days'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4),
                  child: Text(
                    'Days',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.secondaryText
                          : AppColors.lightSecondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
