class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 20.0;
  static const double spacingXl = 24.0;
  static const double spacingXxl = 30.0;
  static const double spacingXxxl = 40.0;

  // Border Radius
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 50.0;
  static const double radiusCircle = 1000.0;

  // Font Sizes
  static const double fontSizeXxs = 10.0;
  static const double fontSizeXs = 11.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 13.0;
  static const double fontSizeLg = 14.0;
  static const double fontSizeXl = 16.0;
  static const double fontSizeXxl = 18.0;
  static const double fontSizeXxxl = 20.0;
  static const double fontSizeHuge = 24.0;
  static const double fontSizeMassive = 32.0;

  // Icon Sizes
  static const double iconSizeSm = 24.0;
  static const double iconSizeMd = 26.0;
  static const double iconSizeFab = 28.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 35.0;
  static const double iconSizeXxl = 40.0;

  // Button Heights
  static const double buttonHeight = 56.0;

  // Avatar Sizes
  static const double avatarSizeSm = 38.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeDefault = 48.0;
  static const double avatarSizeLg = 56.0;

  // Card/Container Sizes
  static const double cardHeightSm = 40.0;
  static const double cardHeightMd = 58.0;
  static const double cardHeightLg = 80.0;

  /// Spacing above / below the Save–Update CTA at the end of the add/edit habit form.
  static const double habitFormSaveButtonTopSpacing = spacingXxl;
  static const double habitFormSaveButtonBottomSpacing = spacingMd;

  // Bottom Bar
  static const double bottomBarHeight = 58.0;
  static const double bottomBarWidthRatio = 0.92;
  static const double bottomBarOffset = 10.0;
  static const double bottomBarStartIndex = 2;
  static const double bottomBarEndIndex = 0;

  // FAB (Floating Action Button)
  static const double fabSize = 56.0;
  static const double fabOffset = -20.0;
  static const double fabBorderWidth = 4.0;

  // Date Strip
  /// Room for date pill content plus [Material] shadow without clipping.
  static const double dateStripHeight = 88.0;
  static const double dateItemWidth = 60.0;
  static const double dateItemRadius = 20.0;
  static const double dateDotSize = 4.0;

  // Progress Indicator
  static const double progressIndicatorSize = 80.0;
  static const double progressStrokeWidth = 8.0;

  // Grid
  static const int gridCrossAxisCount = 4;

  // Tab Controller
  static const int tabCount = 5;
  static const int daysToShow = 14;
  static const int dateOffsetDays = 7;

  // Animation
  static const int animationDurationMs = 500;

  // Shadow
  static const double shadowBlurSm = 10.0;
  static const double shadowBlurMd = 15.0;
  static const double shadowOffsetY = 4.0;
  static const double shadowOffsetYLarge = 8.0;

  // Opacity
  static const double opacityXxs = 0.05;
  static const double opacityXs = 0.1;
  static const double opacitySm = 0.2;
  static const double opacityMd = 0.3;
  static const double opacityLg = 0.4;

  // Border Width
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;

  // Line Height
  static const double lineHeight = 1.5;

  // Letter Spacing
  static const double letterSpacing = 1.2;

  // Loader Size
  static const double loaderSize = 24.0;
  static const double loaderStrokeWidth = 2.0;

  // Bottom Padding for Scroll
  static const double bottomScrollPadding = 120.0;

  // Toast
  static const double toastTopPadding = 60.0;
  static const double toastHorizontalPadding = 20.0;
  static const double toastVerticalPadding = 12.0;
  static const double toastHorizontalMargin = 32.0;
  static const double toastIconSize = 22.0;
  static const double toastIconSpacing = 12.0;

  // Password Minimum Length
  static const int passwordMinLength = 6;

  // Statistics Screen
  static const double heatmapContainerRadius = 8.0;
  static const double chartBarWidth = 20.0;
  static const double chartBarRadius = 6.0;
  static const double chartHeight = 150.0;
  static const int chartBarMinValue = 12;
  /// Label row height for consistency chart (weekday/month labels below bars).
  static const double consistencyChartLabelRowHeight = 14.0;
  /// Total height of consistency chart content (bars + spacing + label row). Use same for Week and Month so card bottom padding is identical.
  static const double consistencyChartContentHeight = chartHeight + spacingMd + consistencyChartLabelRowHeight;
  static const double chartBarOpacityLow = 0.55;
  static const double heatmapOpacityMin = 0.25;
  static const double heatmapOpacityMax = opacityHigh;

  // Streak Card
  static const double streakCardWidth = 140.0;
  /// Statistics "Top Streaks" horizontal strip: must fit ring + labels + padding/margins without overflow.
  static const double topStreaksStripHeight = 210.0;
  static const double streakProgressSize = 60.0;
  static const double streakProgressStrokeWidth = 4.0;
  /// Habit name under the streak value (Top Streaks cards).
  static const double fontSizeStreakTitle = 12;
  /// Ring opacity when habit has no progress (not completed yet).
  static const double streakProgressOpacityIncomplete = 0.35;
  /// Ring opacity when habit is completed (progress fill).
  static const double streakProgressOpacityComplete = opacityHigh;

  // Profile Avatar
  static const double avatarSizeXl = 100.0;

  // Chip (filter + sort order, same row; filter uses spacingXs + radiusMd)
  static const double chipHeight = 36.0;
  static const double sortChipMinWidth = 48.0;
  static const double sortChipMaxWidth = 72.0;

  // Tab/Toggle Item
  static const double tabHorizontalPadding = 20.0;
  static const double tabVerticalPadding = 10.0;
  static const double toggleHorizontalPadding = 12.0;
  static const double toggleVerticalPadding = 6.0;
  static const double toggleRadius = 6.0;

  // Profile Menu
  static const double menuItemHeight = 60.0;

  // Social Button
  static const double socialIconSize = 24.0;

  // Toast Duration
  static const int toastDurationSeconds = 3;

  // Opacity
  static const double opacityHalf = 0.5;
  static const double opacityHigh = 0.8;
  static const double opacityFull = 1.0;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;

  // Form Padding
  static const double formContentSpacing = 200.0;

  // Reminder overlay (habit_reminder_page)
  static const double reminderTitleFontSize = 40.0;
  static const double reminderDescriptionFontSize = 18.0;
  static const double reminderHorizontalPadding = 30.0;
  static const double reminderContentPadding = 30.0;
  static const double reminderButtonHeight = 70.0;
  static const double reminderButtonBorderRadius = 20.0;
  static const double reminderButtonElevation = 10.0;
  static const double reminderIconContainerPadding = 30.0;
  static const double reminderIconSize = 100.0;
  static const double reminderIconShadowBlur = 30.0;
  static const double reminderIconShadowSpread = 10.0;
  static const int reminderPulseAnimationDurationSeconds = 2;
  static const double reminderGradientOverlayOpacity = 0.9;
  static const double reminderPulseScaleMin = 0.9;
  static const double reminderPulseScaleMax = 1.1;
  static const double reminderDescriptionOpacity = 0.8;
  static const double reminderDismissTextOpacity = 0.7;
  static const double reminderIconBgOpacity = 0.2;
  static const double reminderIconShadowOpacity = 0.5;

  // Add habit / forms
  static const int snackBarFullScreenIntentDurationSeconds = 6;
  static const double alertTimeFieldWidth = 52.0;

  // Icon picker (bottom sheet)
  static const double iconPickerInitialChildSize = 0.75;
  static const double iconPickerMinChildSize = 0.4;
  static const double iconPickerMaxChildSize = 0.95;
  static const List<double> iconPickerSnapSizes = [0.5, 0.75, 0.95];
  static const double iconPickerSheetBorderRadius = 20.0;
  static const double iconPickerHandleWidth = 36.0;
  static const double iconPickerHandleHeight = 4.0;
  static const double iconPickerHandleBorderRadius = 2.0;
  static const double iconPickerHandleOpacity = 0.15;
  static const double iconPickerPrefixIconOpacity = 0.4;
  static const double iconPickerFillOpacity = 0.06;
  static const double iconPickerEmptyOpacity = 0.2;
  static const double iconPickerHintOpacity = 0.35;
  static const double iconPickerBorderOpacity = 0.08;
  static const double iconPickerIconOpacity = 0.55;
  static const double iconPickerSelectedBorderWidth = 1.5;
  static const double iconPickerUnselectedBorderWidth = 0.5;
  static const double iconPickerSearchIconSize = 18.0;
  static const double iconPickerClearIconSize = 16.0;
  static const double iconPickerEmptyStateIconSize = 32.0;
  static const double iconPickerSearchContentPaddingH = 14.0;
  static const double iconPickerSearchContentPaddingV = 10.0;
  static const double iconPickerGridSpacing = 6.0;
  static const double iconPickerGridItemRadius = 10.0;
  static const double iconPickerGridIconSize = 20.0;
  static const double iconPickerSelectedBgOpacity = 0.12;
  static const int iconPickerTooltipWaitMs = 600;
  static const int iconPickerSelectionAnimationMs = 120;

  // Register screen gradient
  static const List<double> registerGradientStops = [0.0, 0.3];

  // App modal bottom sheet ([showAppModalBottomSheet])
  static const double modalBarrierOpacityDefault = 0.45;
  static const double modalDragHandleWidth = 40.0;
  static const double modalDragHandleHeight = 4.0;
  static const double modalDragHandleBorderRadius = 2.0;

  // Achievements main screen ([AchievementsScreen] — hero, grids, monthly card)
  static const double achievementsHeroImpactNumberSize = 60.0;
  static const double achievementsHeroImpactLineHeight = 1.0;
  static const int achievementsWeeklyGridCrossAxisCount = 2;
  static const double achievementsWeeklyGridChildAspectRatio = 1.1;
  static const double achievementsMonthlyProgressRingSize = 72.0;
  static const double achievementsMonthlyProgressRingTintAlpha = 0.1;
  static const double achievementsMonthlyProgressValue = 0.82;
  static const double achievementsMonthlyProgressMinHeight = 10.0;
  static const double achievementsEarnedBadgeIconContainerSize = 36.0;
  static const double achievementsEarnedBadgeGlyphSize = 18.0;
  static const double achievementsYearlyThumbnailSize = 72.0;
  static const double achievementsEarnedLabelLetterSpacing = 0.5;
  static const double achievementsBadgeCapsLetterSpacing = 0.8;
  static const double achievementsYearlyGradientStartAlpha = 0.7;
  static const double achievementsYearlyGradientEndAlpha = 0.5;
  static const double achievementsYearlyBadgeFillAlphaDark = 0.2;
  static const double achievementsYearlyBadgeFillAlphaLight = 0.15;
}
