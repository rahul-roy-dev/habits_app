import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheet_colors.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_theme.dart';

/// Typography for achievement sheets — always pass [BuildContext] for dark mode.
abstract final class AchievementSheetTextStyles {
  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontTitle,
        fontWeight: FontWeight.bold,
        color: AchievementSheetTheme.isDark(context)
            ? AppColors.primaryText
            : AchievementSheetColors.titleBlack,
      );

  static TextStyle subtitleAccent(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontSubtitle,
        fontWeight: FontWeight.bold,
        color: AchievementSheetColors.primaryBlue,
      );

  /// Weekend Warrior subtitle — gym red accent.
  static TextStyle subtitleGym(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontSubtitle,
        fontWeight: FontWeight.bold,
        color: AchievementSheetColors.gymRed,
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontBody,
        height: AchievementSheetDimensions.bodyLineHeight,
        color: AchievementSheetTheme.isDark(context)
            ? AppColors.secondaryText
            : AchievementSheetColors.bodyGrey,
      );

  static TextStyle bodyPerfectionist(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontBody,
        height: AchievementSheetDimensions.bodyLineHeightPerfectionist,
        color: AchievementSheetTheme.isDark(context)
            ? AppColors.secondaryText
            : AchievementSheetColors.bodyGrey,
      );

  static TextStyle unlockCaps(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontUnlockCaps,
        fontWeight: FontWeight.w600,
        letterSpacing: AchievementSheetDimensions.letterSpacingUnlock,
        color: AchievementSheetColors.primaryBlue,
      );

  static TextStyle badgeCaps(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontBadgeCaps,
        fontWeight: FontWeight.bold,
        letterSpacing: AchievementSheetDimensions.letterSpacingBadge,
        color: AchievementSheetTheme.isDark(context)
            ? AchievementSheetColors.mintBadge
            : AchievementSheetColors.mintBadgeDark,
      );

  static TextStyle statLabel(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontStatLabel,
        fontWeight: FontWeight.w600,
        letterSpacing: AchievementSheetDimensions.letterSpacingBadge,
        color: AchievementSheetTheme.isDark(context)
            ? AppColors.secondaryText
            : AchievementSheetColors.statLabelGrey,
      );

  static TextStyle momentumSectionLabel(BuildContext context) => TextStyle(
        fontSize: AchievementSheetDimensions.fontMomentumLabel,
        fontWeight: FontWeight.w600,
        letterSpacing: AchievementSheetDimensions.letterSpacingMomentum,
        color: AchievementSheetTheme.isDark(context)
            ? AppColors.secondaryText
            : AchievementSheetColors.statLabelGrey,
      );

  static TextStyle dayEndLabel(BuildContext context, {required double alpha}) =>
      TextStyle(
        fontSize: AchievementSheetDimensions.fontDayLabel,
        color: (AchievementSheetTheme.isDark(context)
                ? AppColors.secondaryText
                : AchievementSheetColors.statLabelGrey)
            .withValues(alpha: alpha),
      );

  static TextStyle statValue({required double size, required Color color}) =>
      TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      );
}
