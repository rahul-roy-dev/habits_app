import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';

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
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
               fontSize: AppDimensions.fontSizeXxs,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.split('%')[0].split(' ')[0],
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText,
                   fontSize: AppDimensions.fontSizeHuge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isPercentage)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.toggleVerticalPadding, left: AppDimensions.borderWidthMedium),
                  child: Text(
                    '%',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryAccent
                          : AppColors.lightPrimaryAccent,
                      fontSize: AppDimensions.fontSizeXl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (value.contains('Days'))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.toggleVerticalPadding, left: AppDimensions.spacingXxs),
                  child: Text(
                    'Days',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.secondaryText
                          : AppColors.lightSecondaryText,
                      fontSize: AppDimensions.fontSizeSm,
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
