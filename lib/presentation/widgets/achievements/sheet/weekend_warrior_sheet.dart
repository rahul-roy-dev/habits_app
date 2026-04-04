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

Future<void> showWeekendWarriorSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    useSafeArea: false,
    builder: (_) => const _WeekendWarriorSheet(),
  );
}

class _WeekendWarriorSheet extends StatelessWidget {
  const _WeekendWarriorSheet();

  static const int _momentumDays = 7;
  static const int _weekendStartIndex = 5;

  @override
  Widget build(BuildContext context) {
    final isDark = AchievementSheetTheme.isDark(context);
    return AchievementSheetShell(
      backgroundColor: AchievementSheetTheme.scaffoldBackground(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSheetDragHandle(),
          SizedBox(height: AchievementSheetDimensions.spacingSm),
          Center(
            child: AchievementHeroIcon.weekendWarrior(
              size: AchievementHeroSize.sheetSmall,
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXl),
          Text(
            AchievementSheetStrings.weekendTitle,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.title(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingTight),
          Text(
            AchievementSheetStrings.weekendSubtitle,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.subtitleGym(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingMd),
          Text(
            AchievementSheetStrings.weekendBody,
            textAlign: TextAlign.center,
            style: AchievementSheetTextStyles.body(context),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXxxl),
          AchievementStatRow(
            left: AchievementStatFlatCard(
              label: AchievementSheetStrings.weekendStatStreakLabel,
              valueText: AchievementSheetStrings.weekendStatStreakValue,
              valueColor: AchievementSheetTheme.onSurfacePrimary(context),
            ),
            right: AchievementStatFlatCard(
              label: AchievementSheetStrings.weekendStatDaysLabel,
              valueText: AchievementSheetStrings.weekendStatDaysValue,
              valueColor: AchievementSheetTheme.onSurfacePrimary(context),
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXxxl),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AchievementSheetStrings.weekendMomentumLabel,
              style: AchievementSheetTextStyles.momentumSectionLabel(context),
            ),
          ),
          SizedBox(height: AchievementSheetDimensions.momentumSectionTopGap),
          Row(
            children: List.generate(_momentumDays, (i) {
              final active = i >= _weekendStartIndex;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : AchievementSheetDimensions.momentumBlockGap,
                  ),
                  child: Container(
                    height: AchievementSheetDimensions.momentumBlockHeight,
                    decoration: BoxDecoration(
                      color: active
                          ? AchievementSheetColors.gymRed
                          : (isDark
                              ? AchievementSheetColors.momentumInactiveDark
                              : AchievementSheetColors.momentumInactive),
                      borderRadius: BorderRadius.circular(
                        AchievementSheetDimensions.momentumBlockRadius,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: AchievementSheetDimensions.momentumLabelGap),
          Row(
            children: List.generate(_momentumDays, (i) {
              if (i == 0) {
                return Expanded(
                  child: Text(
                    AchievementSheetStrings.weekendDayMon,
                    style: AchievementSheetTextStyles.dayEndLabel(context, alpha: 0.9),
                  ),
                );
              }
              if (i == _momentumDays - 1) {
                return Expanded(
                  child: Text(
                    AchievementSheetStrings.weekendDaySun,
                    textAlign: TextAlign.right,
                    style: AchievementSheetTextStyles.dayEndLabel(context, alpha: 0.9),
                  ),
                );
              }
              return const Expanded(child: SizedBox());
            }),
          ),
          SizedBox(height: AchievementSheetDimensions.spacingXxxl),
          CustomButton(
            text: AchievementSheetStrings.weekendCta,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
