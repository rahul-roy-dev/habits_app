import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheet_colors.dart';

/// Visual scale: grid tiles vs sheet heroes (same glow recipe, different metrics).
enum AchievementHeroSize {
  /// Weekly Milestones grid (56px).
  grid,

  /// 7-Day sheet hero (112px, strong glow).
  sheetLarge,

  /// Perfectionist sheet hero (~104px).
  sheetMedium,

  /// First Step / Weekend sheet hero (100px).
  sheetSmall,
}

extension AchievementHeroSizeMetrics on AchievementHeroSize {
  double get diameter {
    switch (this) {
      case AchievementHeroSize.grid:
        return AchievementSheetDimensions.weeklyMilestoneIconDiameter;
      case AchievementHeroSize.sheetLarge:
        return AchievementSheetDimensions.heroIconHeroLarge;
      case AchievementHeroSize.sheetMedium:
        return AchievementSheetDimensions.heroIconHeroMedium;
      case AchievementHeroSize.sheetSmall:
        return AchievementSheetDimensions.heroIconHeroSmall;
    }
  }

  double get glowBlur {
    switch (this) {
      case AchievementHeroSize.grid:
        return AchievementSheetDimensions.weeklyMilestoneGlowBlur;
      case AchievementHeroSize.sheetLarge:
        return AchievementSheetDimensions.streakOrangeGlowBlur;
      case AchievementHeroSize.sheetMedium:
        return AchievementSheetDimensions.heroSheetMediumGlowBlur;
      case AchievementHeroSize.sheetSmall:
        return AchievementSheetDimensions.heroSheetSmallGlowBlur;
    }
  }

  double get glowSpread {
    switch (this) {
      case AchievementHeroSize.grid:
        return AchievementSheetDimensions.weeklyMilestoneGlowSpread;
      case AchievementHeroSize.sheetLarge:
        return AchievementSheetDimensions.streakOrangeGlowSpread;
      case AchievementHeroSize.sheetMedium:
        return AchievementSheetDimensions.heroSheetMediumGlowSpread;
      case AchievementHeroSize.sheetSmall:
        return AchievementSheetDimensions.heroSheetSmallGlowSpread;
    }
  }
}

/// Circular glyph with soft outer glow — shared by Weekly Milestones and achievement sheets.
class AchievementHeroIcon extends StatelessWidget {
  const AchievementHeroIcon({
    super.key,
    required this.icon,
    required this.glowColor,
    required this.iconColor,
    required this.glowAlpha,
    required this.size,
    this.glyphSize,
    this.glowBlurOverride,
    this.glowSpreadOverride,
  });

  final IconData icon;
  final Color glowColor;
  final Color iconColor;
  final double glowAlpha;
  final AchievementHeroSize size;
  final double? glyphSize;

  /// When set, used instead of [size].glowBlur (e.g. First Step grid matches sheet glow).
  final double? glowBlurOverride;

  /// When set, used instead of [size].glowSpread.
  final double? glowSpreadOverride;

  /// Soft disc: light theme lerps from white; dark theme lerps from [AchievementSheetColors.discDarkBase].
  static Color discColorForGlow(Color glow, {required bool isDark}) {
    final t = AchievementSheetDimensions.weeklyMilestoneDiscTint;
    final base = isDark ? AchievementSheetColors.discDarkBase : Colors.white;
    final amount = isDark
        ? t * AchievementSheetDimensions.weeklyMilestoneDiscTintDarkMultiplier
        : t;
    return Color.lerp(base, glow, amount)!;
  }

  factory AchievementHeroIcon.sevenDayStreak({
    AchievementHeroSize size = AchievementHeroSize.grid,
  }) {
    const glow = AchievementSheetColors.streakOrange;
    return AchievementHeroIcon(
      icon: LucideIcons.flame,
      glowColor: glow,
      iconColor: glow,
      glowAlpha: size == AchievementHeroSize.grid
          ? AchievementSheetDimensions.weeklyMilestoneGlowAlpha
          : AchievementSheetDimensions.streakOrangeGlowAlpha,
      size: size,
    );
  }

  factory AchievementHeroIcon.perfectionist({
    AchievementHeroSize size = AchievementHeroSize.grid,
  }) {
    const glow = AchievementSheetColors.successGreen;
    return AchievementHeroIcon(
      icon: Icons.check,
      glowColor: glow,
      iconColor: glow,
      glowAlpha: size == AchievementHeroSize.grid
          ? AchievementSheetDimensions.weeklyMilestoneGlowAlpha
          : AchievementSheetDimensions.streakOrangeGlowAlpha,
      size: size,
    );
  }

  factory AchievementHeroIcon.firstStep({
    required bool unlocked,
    AchievementHeroSize size = AchievementHeroSize.grid,
  }) {
    const glow = AchievementSheetColors.primaryBlue;
    // Same blue bolt + soft blue glow as the sheet; locked = weaker halo only.
    return AchievementHeroIcon(
      icon: LucideIcons.zap,
      glowColor: glow,
      iconColor: glow,
      glowAlpha: unlocked
          ? AchievementSheetDimensions.streakOrangeGlowAlpha
          : AchievementSheetDimensions.weeklyMilestoneGlowAlphaLocked,
      size: size,
      glowBlurOverride: size == AchievementHeroSize.grid
          ? AchievementSheetDimensions.heroSheetSmallGlowBlur
          : null,
      glowSpreadOverride: size == AchievementHeroSize.grid
          ? AchievementSheetDimensions.heroSheetSmallGlowSpread
          : null,
    );
  }

  /// Weekend Warrior / gym — red glow, red icon, same disc treatment.
  factory AchievementHeroIcon.weekendWarrior({
    AchievementHeroSize size = AchievementHeroSize.grid,
  }) {
    const glow = AchievementSheetColors.gymRed;
    return AchievementHeroIcon(
      icon: LucideIcons.dumbbell,
      glowColor: glow,
      iconColor: glow,
      glowAlpha: size == AchievementHeroSize.grid
          ? AchievementSheetDimensions.weeklyMilestoneGlowAlpha
          : AchievementSheetDimensions.streakOrangeGlowAlpha,
      size: size,
    );
  }

  double _defaultGlyphSize() {
    switch (size) {
      case AchievementHeroSize.grid:
        return AchievementSheetDimensions.weeklyMilestoneGlyphSize;
      case AchievementHeroSize.sheetLarge:
        return AchievementSheetDimensions.flameHeroIconSize;
      case AchievementHeroSize.sheetMedium:
        return AchievementSheetDimensions.heroIconGlyphMedium;
      case AchievementHeroSize.sheetSmall:
        return AchievementSheetDimensions.heroIconGlyphSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final d = size.diameter;
    final blur = glowBlurOverride ?? size.glowBlur;
    final spread = glowSpreadOverride ?? size.glowSpread;
    final g = glyphSize ?? _defaultGlyphSize();

    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: discColorForGlow(glowColor, isDark: isDark),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: glowAlpha),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: g, color: iconColor),
      ),
    );
  }
}

/// Grid-only alias (same widget).
typedef WeeklyMilestoneHeroIcon = AchievementHeroIcon;
