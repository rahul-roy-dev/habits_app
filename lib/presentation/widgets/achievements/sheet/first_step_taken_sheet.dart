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
import 'package:habits_app/presentation/widgets/common/app_modal_bottom_sheet.dart';

Future<void> showFirstStepTakenSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => const _FirstStepTakenSheet(),
  );
}

class _FirstStepTakenSheet extends StatelessWidget {
  const _FirstStepTakenSheet();

  @override
  Widget build(BuildContext context) {
    return AchievementSheetShell(
      backgroundColor: AchievementSheetTheme.scaffoldBackground(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppSheetDragHandle(),
          SizedBox(height: AchievementSheetDimensions.spacingSm),
          AchievementHeroIcon.firstStep(
            unlocked: true,
            size: AchievementHeroSize.sheetSmall,
          ),
          SizedBox(height: AchievementSheetDimensions.spacingLg),
          Text(
            AchievementSheetStrings.firstStepUnlockLine,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.unlockCaps(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingSm),
          Text(
            AchievementSheetStrings.firstStepTitle,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.title(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingMd),
          Text(
            AchievementSheetStrings.firstStepBody,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.body(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXxxl),
          AchievementStatRow(
            left: AchievementStatFlatCard(
              label: AchievementSheetStrings.firstStepStatTotalLabel,
              valueText: AchievementSheetStrings.firstStepStatTotalValue,
              valueColor: AchievementSheetTheme.onSurfacePrimary(context),
            ),
            right: AchievementStatFlatCard(
              label: AchievementSheetStrings.firstStepStatMilestoneLabel,
              valueText: AchievementSheetStrings.firstStepStatMilestoneValue,
              valueColor: AchievementSheetColors.primaryBlue,
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingHuge),
          CustomButton(
            text: AchievementSheetStrings.firstStepCta,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
