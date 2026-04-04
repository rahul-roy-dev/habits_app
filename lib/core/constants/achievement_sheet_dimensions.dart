/// Layout and typography metrics for achievement celebration bottom sheets.
abstract final class AchievementSheetDimensions {
  AchievementSheetDimensions._();

  static const double sheetMaxHeightFraction = 0.92;
  static const double sheetTopCornerRadius = 28;
  static const double sheetHorizontalPadding = 24;
  static const double sheetBottomPadding = 28;

  static const double spacingAfterHandle = 8;
  static const double spacingTight = 6;
  static const double spacingSm = 12;
  static const double spacingMd = 14;
  static const double spacingLg = 16;
  static const double spacingXl = 18;
  static const double spacingXxl = 20;
  static const double spacingXxxl = 22;
  static const double spacingHuge = 24;
  static const double spacingAfterButton = 28;

  static const double heroIconHeroLarge = 112;
  static const double heroIconHeroMedium = 104;
  static const double heroIconHeroSmall = 100;
  static const double heroIconInnerRing = 92;
  static const double heroIconCheckCircle = 64;

  static const double flameHeroIconSize = 52;
  static const double zapHeroIconSize = 40;
  static const double dumbbellHeroIconSize = 44;
  static const double checkIconPerfectionist = 34;
  static const double heroIconGlyphMedium = 44;
  static const double heroIconGlyphSmall = 40;

  static const double heroSheetMediumGlowBlur = 20;
  static const double heroSheetMediumGlowSpread = 1.5;
  static const double heroSheetSmallGlowBlur = 18;
  static const double heroSheetSmallGlowSpread = 1;

  static const double streakDotCompleted = 36;
  static const double streakDotCurrent = 40;
  static const double streakDotCheckIcon = 18;
  static const double streakDotFlameIcon = 20;

  static const double streakOrangeGlowBlur = 24;
  static const double streakOrangeGlowSpread = 2;
  static const double streakOrangeGlowAlpha = 0.35;

  /// Weekly Milestones grid: same glow recipe as the 7-Day sheet hero, scaled to the card.
  static const double weeklyMilestoneIconDiameter = 56;
  static const double weeklyMilestoneGlyphSize = 26;
  static const double weeklyMilestoneGlowBlur = 12;
  static const double weeklyMilestoneGlowSpread = 1;
  static const double weeklyMilestoneGlowAlpha = 0.35;
  static const double weeklyMilestoneGlowAlphaLocked = 0.22;

  /// Disc fill: [Color.lerp] from white toward the glow hue (0 = white, 1 = full glow).
  static const double weeklyMilestoneDiscTint = 0.14;

  static const double streakDotFlameBlur = 8;
  static const double streakDotFlameSpread = 1;
  static const double streakDotFlameShadowAlpha = 0.45;
  static const double streakDotBorderWidth = 2;
  static const double streakDotBorderAlpha = 0.35;

  static const double dayStreakDotGap = 6;

  static const double perfectionistOuterShadowBlur = 16;
  static const double perfectionistOuterShadowOffsetY = 4;
  static const double perfectionistOuterShadowAlpha = 0.08;
  static const double perfectionistMintRingWidth = 5;

  static const double badgeHorizontalPadding = 14;
  static const double badgeVerticalPadding = 8;
  static const double badgeIconGap = 8;

  static const double statCardShadowRadius = 20;
  static const double statCardFlatRadius = 16;
  static const double statCardShadowHPadding = 14;
  static const double statCardShadowVPadding = 16;
  static const double statCardFlatHPadding = 12;
  static const double statCardFlatVPadding = 14;
  static const double statRowGap = 12;
  static const double statLabelValueGap = 8;
  static const double statLabelValueGapTight = 6;

  /// Dark-mode flat stat card border ([AchievementStatFlatCard]).
  static const double statFlatCardBorderAlphaDark = 0.12;

  /// Dark theme: [AchievementSheetTheme.statFlatCardFill] over [AppColors.inputBackground].
  static const double statFlatCardFillAlphaDark = 0.92;

  /// Dark theme: mint badge on Perfectionist sheet.
  static const double mintBadgeFillAlphaDark = 0.22;

  /// Dark theme: drag handle on sheets / modals.
  static const double sheetHandleAlphaDark = 0.35;

  /// Dark theme: extra blend on hero disc vs [weeklyMilestoneDiscTint].
  static const double weeklyMilestoneDiscTintDarkMultiplier = 1.12;

  /// Habit "end after N days" Cupertino picker (matches iOS-style wheel height).
  static const double habitEndDaysPickerHeight = 216;
  static const double habitEndDaysPickerItemExtent = 36;

  static const double momentumBlockHeight = 36;
  static const double momentumBlockRadius = 8;
  static const double momentumBlockGap = 4;
  static const double momentumLabelGap = 6;
  static const double momentumSectionTopGap = 10;

  static const double pillBorderRadius = 999;

  // Font sizes (sheet-specific; keep separate from global scale where design differs)
  static const double fontTitle = 26;
  static const double fontSubtitle = 17;
  static const double fontBody = 15;
  static const double fontUnlockCaps = 12;
  static const double fontBadgeCaps = 12;
  static const double fontStatValueLarge = 22;
  static const double fontStatValueMedium = 18;
  static const double fontStatLabel = 10;
  static const double fontMomentumLabel = 11;
  static const double fontDayLabel = 10;

  static const double bodyLineHeight = 1.45;
  static const double bodyLineHeightPerfectionist = 1.5;

  static const double letterSpacingUnlock = 0.9;
  static const double letterSpacingBadge = 0.6;
  static const double letterSpacingMomentum = 0.8;

  static const int perfectionistMintRingColor = 0xFFA7F3D0;
}
