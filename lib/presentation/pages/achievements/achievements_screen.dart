import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/common/habits_app_bar.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_sheets.dart';
import 'package:habits_app/presentation/widgets/achievements/achievement_hero_icon.dart';

class AchievementsScreen extends StatelessWidget {
  final ScrollController? scrollController;

  const AchievementsScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HabitsAppBar(
        title: 'Achievements',
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.only(
          left: AppDimensions.spacingLg,
          right: AppDimensions.spacingLg,
          top: AppDimensions.spacingMd,
          bottom: AppDimensions.bottomScrollPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroStatsBlock(isDark: isDark),
            const SizedBox(height: AppDimensions.spacingXxxl),
            _WeeklyMilestonesSection(isDark: isDark),
            const SizedBox(height: AppDimensions.spacingXxxl),
            _MonthlyAchievementsSection(isDark: isDark),
            const SizedBox(height: AppDimensions.spacingXxxl),
            _YearlyMilestonesSection(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero Stats Block
// ─────────────────────────────────────────────
class _HeroStatsBlock extends StatelessWidget {
  final bool isDark;

  const _HeroStatsBlock({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOTAL IMPACT',
          style: TextStyle(
            color: isDark
                ? AppColors.primaryAccent
                : AppColors.lightPrimaryAccent,
            fontSize: AppDimensions.fontSizeXs,
            fontWeight: FontWeight.bold,
            letterSpacing: AppDimensions.letterSpacing,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXxs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '1,284',
              style: TextStyle(
                color:
                    isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
                fontSize: AppDimensions.achievementsHeroImpactNumberSize,
                fontWeight: FontWeight.bold,
                height: AppDimensions.achievementsHeroImpactLineHeight,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              'habits',
              style: TextStyle(
                color: isDark
                    ? AppColors.secondaryAccent
                    : AppColors.lightSuccess,
                fontSize: AppDimensions.fontSizeXxxl,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Weekly Milestones Section
// ─────────────────────────────────────────────
class _WeeklyMilestonesSection extends StatelessWidget {
  final bool isDark;

  const _WeeklyMilestonesSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Weekly Milestones',
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
                fontSize: AppDimensions.fontSizeXxxl,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Goal: 5/7',
              style: TextStyle(
                color: isDark
                    ? AppColors.secondaryText
                    : AppColors.lightSecondaryText,
                fontSize: AppDimensions.fontSizeXs,
                fontWeight: FontWeight.bold,
                letterSpacing: AppDimensions.letterSpacing,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: AppDimensions.achievementsWeeklyGridCrossAxisCount,
          crossAxisSpacing: AppDimensions.spacingMd,
          mainAxisSpacing: AppDimensions.spacingMd,
          childAspectRatio:
              AppDimensions.achievementsWeeklyGridChildAspectRatio,
          children: [
            _BadgeCard(
              isDark: isDark,
              milestoneIcon: WeeklyMilestoneHeroIcon.sevenDayStreak(),
              title: '7-Day Streak',
              subtitle: 'Unstoppable force',
              isUnlocked: true,
              onTap: (context) => showSevenDayStreakSheet(context),
            ),
            _BadgeCard(
              isDark: isDark,
              milestoneIcon: WeeklyMilestoneHeroIcon.perfectionist(),
              title: 'Perfectionist',
              subtitle: '100% completion',
              isUnlocked: true,
              onTap: (context) => showPerfectionistSheet(context),
            ),
            _BadgeCard(
              isDark: isDark,
              milestoneIcon: WeeklyMilestoneHeroIcon.firstStep(unlocked: false),
              title: 'First Step',
              subtitle: 'Unlock at 10 habits',
              isUnlocked: false,
              onTap: (context) => showFirstStepTakenSheet(context),
            ),
            _BadgeCard(
              isDark: isDark,
              milestoneIcon: WeeklyMilestoneHeroIcon.weekendWarrior(),
              title: 'Weekend Warrior',
              subtitle: 'Sat & Sun tracked',
              isUnlocked: true,
              onTap: (context) => showWeekendWarriorSheet(context),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final bool isDark;
  final Widget milestoneIcon;
  final String title;
  final String subtitle;
  final bool isUnlocked;
  final void Function(BuildContext context)? onTap;

  const _BadgeCard({
    required this.isDark,
    required this.milestoneIcon,
    required this.title,
    required this.subtitle,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardSurface =
        isDark ? AppColors.surface : AppColors.lightSurface;

    final card = Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
            blurRadius: AppDimensions.shadowBlurMd,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          milestoneIcon,
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isUnlocked
                  ? (isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText)
                  : (isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText),
              fontSize: AppDimensions.fontSizeXl,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXxs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
              fontSize: AppDimensions.fontSizeXs,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: () => onTap!(context),
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }
    return card;
  }
}

// ─────────────────────────────────────────────
// Monthly Achievements Section
// ─────────────────────────────────────────────
class _MonthlyAchievementsSection extends StatelessWidget {
  final bool isDark;

  const _MonthlyAchievementsSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardSurface =
        isDark ? AppColors.surface : AppColors.lightSurface;
    final primaryColor =
        isDark ? AppColors.primaryAccent : AppColors.lightPrimaryAccent;
    final secondaryColor =
        isDark ? AppColors.secondaryAccent : AppColors.lightSuccess;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Achievements',
          style: TextStyle(
            color: isDark
                ? AppColors.primaryText
                : AppColors.lightPrimaryText,
            fontSize: AppDimensions.fontSizeXxxl,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          decoration: BoxDecoration(
            color: cardSurface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: AppDimensions.opacitySm),
                blurRadius: AppDimensions.shadowBlurMd,
                offset: const Offset(0, AppDimensions.shadowOffsetY),
              ),
            ],
          ),
          child: Column(
            children: [
              // Progress header
              Row(
                children: [
                  Container(
                    width: AppDimensions.achievementsMonthlyProgressRingSize,
                    height: AppDimensions.achievementsMonthlyProgressRingSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(
                        alpha:
                            AppDimensions.achievementsMonthlyProgressRingTintAlpha,
                      ),
                      border: Border.all(color: primaryColor, width: AppDimensions.borderWidthMedium),
                    ),
                    child: Icon(
                      LucideIcons.calendar_days,
                      color: primaryColor,
                      size: AppDimensions.iconSizeLg,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Oct Consistency',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.primaryText
                                    : AppColors.lightPrimaryText,
                                fontSize: AppDimensions.fontSizeXxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '82%',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: AppDimensions.fontSizeXxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCircle),
                          child: LinearProgressIndicator(
                            value: AppDimensions.achievementsMonthlyProgressValue,
                            minHeight:
                                AppDimensions.achievementsMonthlyProgressMinHeight,
                            backgroundColor: isDark
                                ? AppColors.inputBackground
                                : AppColors.lightInputBackground,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingXxs),
                        Text(
                          '24 of 30 days completed. Keep pushing!',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.secondaryText
                                : AppColors.lightSecondaryText,
                            fontSize: AppDimensions.fontSizeMd,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXl),
              // Earned badges row
              Row(
                children: [
                  Expanded(
                    child: _EarnedBadge(
                      isDark: isDark,
                      icon: LucideIcons.star,
                      bgColor: secondaryColor,
                      iconColor: Colors.white,
                      title: '30 Day Streak',
                      earnedLabel: 'EARNED OCT 12',
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: _EarnedBadge(
                      isDark: isDark,
                      icon: LucideIcons.rocket,
                      bgColor: primaryColor,
                      iconColor: Colors.white,
                      title: 'Speed Runner',
                      earnedLabel: 'EARNED OCT 04',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EarnedBadge extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final String earnedLabel;

  const _EarnedBadge({
    required this.isDark,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.earnedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.inputBackground
            : AppColors.lightInputBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.achievementsEarnedBadgeIconContainerSize,
            height: AppDimensions.achievementsEarnedBadgeIconContainerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: AppDimensions.achievementsEarnedBadgeGlyphSize,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  earnedLabel,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: AppDimensions.fontSizeXs,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Yearly Milestones Section
// ─────────────────────────────────────────────
class _YearlyMilestonesSection extends StatelessWidget {
  final bool isDark;

  const _YearlyMilestonesSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yearly Milestones',
          style: TextStyle(
            color: isDark
                ? AppColors.primaryText
                : AppColors.lightPrimaryText,
            fontSize: AppDimensions.fontSizeXxxl,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Column(
          children: [
            _YearlyCard(
              isDark: isDark,
              icon: LucideIcons.mountain_snow,
              gradientColors: const [
                AppColors.primaryAccentDark,
                AppColors.primaryAccent,
              ],
              title: '1000 Habits Completed',
              description:
                  'A journey of a thousand miles. You\'ve reached the summit of consistency.',
              badgeLabel: 'LEGENDARY',
              badgeColor: isDark
                  ? AppColors.secondaryAccent
                  : AppColors.lightSuccess,
              badgeTextColor: Colors.white,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _YearlyCard(
              isDark: isDark,
              icon: LucideIcons.compass,
              gradientColors: [
                AppColors.primaryAccent.withValues(
                  alpha: AppDimensions.achievementsYearlyGradientStartAlpha,
                ),
                AppColors.primaryAccentDark.withValues(
                  alpha: AppDimensions.achievementsYearlyGradientEndAlpha,
                ),
              ],
              title: 'Yearly Habit Pioneer',
              description:
                  'Creating new paths. You have launched 12 unique habit tracks this year.',
              badgeLabel: 'EXPLORER',
              badgeColor: isDark
                  ? AppColors.primaryAccent.withValues(
                      alpha: AppDimensions.achievementsYearlyBadgeFillAlphaDark,
                    )
                  : AppColors.lightPrimaryAccent.withValues(
                      alpha:
                          AppDimensions.achievementsYearlyBadgeFillAlphaLight,
                    ),
              badgeTextColor: isDark
                  ? AppColors.primaryAccent
                  : AppColors.lightPrimaryAccent,
            ),
          ],
        ),
      ],
    );
  }
}

class _YearlyCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String description;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const _YearlyCard({
    required this.isDark,
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.description,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardSurface =
        isDark ? AppColors.surface : AppColors.lightSurface;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
            blurRadius: AppDimensions.shadowBlurMd,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: AppDimensions.iconSizeLg),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXxs),
                Text(
                  description,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: AppDimensions.fontSizeMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingXs,
                    vertical: AppDimensions.spacingXxs,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.spacingXxs),
                  ),
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      color: badgeTextColor,
                      fontSize: AppDimensions.fontSizeXs,
                      fontWeight: FontWeight.bold,
                      letterSpacing:
                          AppDimensions.achievementsBadgeCapsLetterSpacing,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
