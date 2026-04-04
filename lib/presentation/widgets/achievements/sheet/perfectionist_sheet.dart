import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/constants/achievement_sheet_strings.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_hero_icon.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheet_colors.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_shell.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_text_styles.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_theme.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/widgets/achievement_stat_cards.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/app_modal_bottom_sheet.dart';

Future<void> showPerfectionistSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => const _PerfectionistSheet(),
  );
}

class _PerfectionistSheet extends StatelessWidget {
  const _PerfectionistSheet();

  @override
  Widget build(BuildContext context) {
    return AchievementSheetShell(
      backgroundColor: AchievementSheetTheme.perfectionistScaffoldBackground(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppSheetDragHandle(),
          SizedBox(height: AchievementSheetDimensions.spacingSm),
          AchievementHeroIcon.perfectionist(size: AchievementHeroSize.sheetMedium),
          SizedBox(height: AchievementSheetDimensions.spacingXxl),
          Text(
            AchievementSheetStrings.perfectionistTitle,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.title(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingMd),
          CustomCard(
            showShadow: false,
            color: AchievementSheetTheme.mintBadgeFill(context),
            borderRadius: AchievementSheetDimensions.pillBorderRadius,
            padding: const EdgeInsets.symmetric(
              horizontal: AchievementSheetDimensions.badgeHorizontalPadding,
              vertical: AchievementSheetDimensions.badgeVerticalPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check,
                  size: 18,
                  color: AchievementSheetColors.mintBadgeDark,
                ),
                SizedBox(width: AchievementSheetDimensions.badgeIconGap),
                Text(
                  AchievementSheetStrings.perfectionistBadge,
                  style: AchievementSheetTextStyles.badgeCaps(context),
                ),
              ],
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingLg),
          Text(
            AchievementSheetStrings.perfectionistBody,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.bodyPerfectionist(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXxxl),
          AchievementStatRow(
            left: AchievementStatShadowCard(
              label: AchievementSheetStrings.perfectionistStatHabitsLabel,
              valueText: AchievementSheetStrings.perfectionistStatHabitsValue,
              valueColor: AchievementSheetColors.primaryBlue,
            ),
            right: AchievementStatShadowCard(
              label: AchievementSheetStrings.perfectionistStatRateLabel,
              valueText: AchievementSheetStrings.perfectionistStatRateValue,
              valueColor: AchievementSheetColors.successGreen,
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingHuge),
          CustomButton(
            text: AchievementSheetStrings.perfectionistCta,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
