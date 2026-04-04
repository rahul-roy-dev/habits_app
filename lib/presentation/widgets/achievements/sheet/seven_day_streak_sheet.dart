import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/constants/achievement_sheet_strings.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_hero_icon.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_shell.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_text_styles.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_theme.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/widgets/seven_day_streak_dots.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/app_modal_bottom_sheet.dart';

Future<void> showSevenDayStreakSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => const _SevenDayStreakSheet(),
  );
}

class _SevenDayStreakSheet extends StatelessWidget {
  const _SevenDayStreakSheet();

  @override
  Widget build(BuildContext context) {
    return AchievementSheetShell(
      backgroundColor: AchievementSheetTheme.scaffoldBackground(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppSheetDragHandle(),
          SizedBox(height: AchievementSheetDimensions.spacingAfterHandle),
          AchievementHeroIcon.sevenDayStreak(size: AchievementHeroSize.sheetLarge),
          SizedBox(height: AchievementSheetDimensions.spacingXxl),
          Text(
            AchievementSheetStrings.sevenDayTitle,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.title(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingMd),
          Text(
            AchievementSheetStrings.sevenDayBody,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.body(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingHuge),
          const SevenDayStreakDots(),
          SizedBox(height: AchievementSheetDimensions.spacingAfterButton),
          CustomButton(
            text: AchievementSheetStrings.sevenDayCta,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
