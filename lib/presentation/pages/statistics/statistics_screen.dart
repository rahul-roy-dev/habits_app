import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/custom_avatar.dart';
import 'package:habits_app/presentation/widgets/common/stat_mini_card.dart';
import 'package:habits_app/presentation/widgets/common/streak_card.dart';
import 'package:habits_app/presentation/widgets/common/toggle_item.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  const StatisticsScreen({super.key, this.scrollController});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await ref.read(authProvider.notifier).checkAuthStatus();
    // derived providers in HabitProvider will automatically update when AuthState changes
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.bar_chart,
          color: isDark
              ? AppColors.primaryAccent
              : AppColors.lightPrimaryAccent,
        ),
        title: Text(
          'Statistics',
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
             padding: EdgeInsets.only(right: AppDimensions.spacingMd),
            child: CustomAvatar(initials: 'AR', size: AppDimensions.avatarSizeSm),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: StatMiniCard(
                    title: 'MONTHLY\nCOMPLETION',
                    value: '84%',
                    isPercentage: true,
                  ),
                ),
                SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: StatMiniCard(title: 'BEST\nSTREAK', value: '24 Days'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            _buildHeatmapSection(),
            const SizedBox(height: AppDimensions.spacingXxl),
            Text(
              'Top Streaks',
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
                fontSize: AppDimensions.fontSizeXxl,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildTopStreaks(),
            const SizedBox(height: AppDimensions.spacingXxl),
            _buildConsistencySection(),
            const SizedBox(height: AppDimensions.spacingXxl),
            _buildInsightCard(),
            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapSection() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Heatmap',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'OCT 14 - OCT 20',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: AppDimensions.fontSizeXxs,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomCard(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                  final opacity = (day == 'M' || day == 'W' || day == 'T' || day == 'S')
                       ? AppDimensions.opacityHigh
                      : AppDimensions.opacityXxs;
                  return Column(
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: AppDimensions.fontSizeXxs,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Container(
                        width: AppDimensions.avatarSizeSm,
                        height: AppDimensions.avatarSizeSm,
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.primaryAccent
                                      : AppColors.lightPrimaryAccent)
                                  .withValues(alpha: opacity),
                          borderRadius: BorderRadius.circular(AppDimensions.heatmapContainerRadius),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopStreaks() {
    return SizedBox(
      height: AppDimensions.cardHeightLg * 2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          StreakCard(
            title: 'MORNING YOGA',
            value: '12 Days',
            progress: 0.7,
            icon: Icons.wb_sunny_outlined,
          ),
          SizedBox(width: AppDimensions.spacingMd),
          StreakCard(
            title: 'HYDRATION',
            value: '8 Days',
            progress: 0.4,
            icon: Icons.local_drink,
          ),
          SizedBox(width: AppDimensions.spacingMd),
          StreakCard(
            title: 'READING',
            value: '15 Days',
            progress: 0.9,
            icon: Icons.menu_book,
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencySection() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consistency',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingXxs),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppDimensions.spacingXs),
                  ),
                  child: const Row(
                    children: [
                      ToggleItem(text: 'W', isSelected: true),
                      ToggleItem(text: 'M', isSelected: false),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomCard(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Column(
                children: [
                  SizedBox(
                     height: AppDimensions.chartHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [60, 80, 70, 100, 75, 85, 40, 90, 100]
                          .map(
                            (h) => Container(
                        width: AppDimensions.chartBarWidth,
                        height: h * 1.5,
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.primaryAccent
                                      : AppColors.lightPrimaryAccent)
                                  .withValues(alpha: h > 80 ? 1.0 : AppDimensions.opacityMd),
                          borderRadius: BorderRadius.circular(AppDimensions.chartBarRadius),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MON',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: AppDimensions.fontSizeXxs,
                        ),
                      ),
                      Text(
                        'LIVE TREND',
                        style: TextStyle(
                          color:
                              (isDark
                                      ? AppColors.primaryText
                                      : AppColors.lightPrimaryText)
                                  .withValues(alpha: AppDimensions.opacityHalf),
                          fontSize: AppDimensions.fontSizeXxs,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'SUN',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: AppDimensions.fontSizeXxs,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInsightCard() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return CustomCard(
          color: (isDark ? AppColors.surface : AppColors.lightSurface)
              .withValues(alpha: AppDimensions.opacityMd),
          child: Row(
            children: [
              Container(
                   padding: const EdgeInsets.all(AppDimensions.spacingXs),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isDark
                      ? AppColors.primaryAccent
                      : AppColors.lightPrimaryAccent,
                   size: AppDimensions.iconSizeSm,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consistency Insight',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXxs),
                    Text(
                      "You're most productive during early hours. Try setting your high-effort habits before 9 AM for a 30% higher success rate.",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: AppDimensions.fontSizeSm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
