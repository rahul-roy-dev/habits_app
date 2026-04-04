import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_text_styles.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_theme.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';

/// Card with app-standard drop shadow (Perfectionist layout).
class AchievementStatShadowCard extends StatelessWidget {
  const AchievementStatShadowCard({
    super.key,
    required this.label,
    required this.valueText,
    required this.valueColor,
  });

  final String label;
  final String valueText;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      showShadow: true,
      color: AchievementSheetTheme.statShadowCardFill(context),
      borderRadius: AchievementSheetDimensions.statCardShadowRadius,
      padding: const EdgeInsets.symmetric(
        horizontal: AchievementSheetDimensions.statCardShadowHPadding,
        vertical: AchievementSheetDimensions.statCardShadowVPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AchievementSheetTextStyles.statLabel(context)),
          SizedBox(height: AchievementSheetDimensions.statLabelValueGap),
          Text(
            valueText,
            style: AchievementSheetTextStyles.statValue(
              size: AchievementSheetDimensions.fontStatValueLarge,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Flat stat card (First Step / Weekend Warrior).
class AchievementStatFlatCard extends StatelessWidget {
  const AchievementStatFlatCard({
    super.key,
    required this.label,
    required this.valueText,
    required this.valueColor,
  });

  final String label;
  final String valueText;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = AchievementSheetTheme.isDark(context);
    return CustomCard(
      showShadow: false,
      color: AchievementSheetTheme.statFlatCardFill(context),
      borderRadius: AchievementSheetDimensions.statCardFlatRadius,
      border: isDark
          ? Border.all(
              color: AppColors.secondaryText.withValues(
                alpha: AchievementSheetDimensions.statFlatCardBorderAlphaDark,
              ),
            )
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AchievementSheetDimensions.statCardFlatHPadding,
        vertical: AchievementSheetDimensions.statCardFlatVPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AchievementSheetTextStyles.statLabel(context)),
          SizedBox(height: AchievementSheetDimensions.statLabelValueGapTight),
          Text(
            valueText,
            style: AchievementSheetTextStyles.statValue(
              size: AchievementSheetDimensions.fontStatValueMedium,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-column row with gap between stat cards.
class AchievementStatRow extends StatelessWidget {
  const AchievementStatRow({
    super.key,
    required this.left,
    required this.right,
  });

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        SizedBox(width: AchievementSheetDimensions.statRowGap),
        Expanded(child: right),
      ],
    );
  }
}
