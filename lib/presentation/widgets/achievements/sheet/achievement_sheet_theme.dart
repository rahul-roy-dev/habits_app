import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheet_colors.dart';

/// Theme-aware surfaces for achievement bottom sheets (aligns with app card colors).
abstract final class AchievementSheetTheme {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffoldBackground(BuildContext context) =>
      isDark(context) ? AppColors.surface : AchievementSheetColors.sheetWhite;

  static Color perfectionistScaffoldBackground(BuildContext context) =>
      isDark(context) ? AppColors.surface : AchievementSheetColors.sheetOffWhite;

  static Color statShadowCardFill(BuildContext context) =>
      isDark(context) ? AppColors.inputBackground : AchievementSheetColors.sheetWhite;

  static Color statFlatCardFill(BuildContext context) =>
      isDark(context)
          ? AppColors.inputBackground.withValues(
              alpha: AchievementSheetDimensions.statFlatCardFillAlphaDark,
            )
          : AchievementSheetColors.lightGreyCard;

  static Color mintBadgeFill(BuildContext context) =>
      isDark(context)
          ? AchievementSheetColors.successGreen.withValues(
              alpha: AchievementSheetDimensions.mintBadgeFillAlphaDark,
            )
          : AchievementSheetColors.mintBadge;

  static Color handleColor(BuildContext context) =>
      isDark(context)
          ? AppColors.secondaryText.withValues(
              alpha: AchievementSheetDimensions.sheetHandleAlphaDark,
            )
          : AchievementSheetColors.handleGrey;

  static Color onSurfacePrimary(BuildContext context) =>
      isDark(context) ? AppColors.primaryText : AchievementSheetColors.titleBlack;
}
