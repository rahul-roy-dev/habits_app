import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/constants/demo_constants.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/custom_avatar.dart';
import 'package:habits_app/presentation/widgets/common/stat_mini_card.dart';
import 'package:habits_app/presentation/widgets/common/streak_card.dart';
import 'package:habits_app/presentation/widgets/common/toggle_item.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/domain/entities/statistics_result.dart';
import 'package:habits_app/presentation/providers/statistics_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  const StatisticsScreen({super.key, this.scrollController});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  bool _isConsistencyWeek = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  Future<void> _initData() async {
    await ref.read(authProvider.notifier).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = ref.watch(statisticsProvider);
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
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: StatMiniCard(
                      title: 'MONTHLY\nCOMPLETION',
                      value: '${stats.monthlyCompletionPercent.round()}%',
                      isPercentage: true,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: StatMiniCard(
                      title: 'BEST\nSTREAK',
                      value: '${stats.bestStreakDays} Days',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: _buildHeatmapSection(stats),
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: Text(
                'Top Streaks',
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText,
                  fontSize: AppDimensions.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            _buildTopStreaksEdgeToEdge(stats),
            const SizedBox(height: AppDimensions.spacingXxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: _buildConsistencySection(stats),
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: _buildInsightCard(stats),
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapSection(StatisticsResult stats) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
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
                  stats.heatmapDateRangeText.isEmpty
                      ? 'No data'
                      : stats.heatmapDateRangeText,
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
                children: List.generate(7, (i) {
                  final value = stats.heatmapWeekdayValues.length > i
                      ? stats.heatmapWeekdayValues[i]
                      : 0.0;
                  final opacity = AppDimensions.heatmapOpacityMin +
                      value * (AppDimensions.heatmapOpacityMax - AppDimensions.heatmapOpacityMin);
                  return Column(
                    children: [
                      Text(
                        days[i],
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
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Top Streaks list edge-to-edge: breaks out of parent padding.
  Widget _buildTopStreaksEdgeToEdge(StatisticsResult stats) {
    if (stats.topStreaksByCategory.isEmpty) {
      return SizedBox(
        height: AppDimensions.cardHeightLg * 2,
        child: Center(
          child: Text(
            'No streaks yet. Complete habits to build them!',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
              fontSize: AppDimensions.fontSizeMd,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final children = <Widget>[];
    for (var i = 0; i < stats.topStreaksByCategory.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: AppDimensions.spacingMd));
      }
      final e = stats.topStreaksByCategory[i];
      final icon = AppValues.getIconData(e.iconKey);
      children.add(StreakCard(
        title: e.title,
        value: '${e.valueDays} Days',
        progress: e.progress,
        icon: icon,
      ));
    }
    return SizedBox(
      height: AppDimensions.cardHeightLg * 2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: AppDimensions.spacingLg,
          right: AppDimensions.spacingLg,
        ),
        children: children,
      ),
    );
  }

  Widget _buildConsistencySection(StatisticsResult stats) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isWeek = _isConsistencyWeek;
        final heights = isWeek
            ? stats.consistencyBarHeightsWeek
            : stats.consistencyBarHeightsMonth;
        final count = heights.length;
        final labels = isWeek
            ? stats.consistencyWeekDayLabels
            : stats.consistencyMonthLabels;
        final useSpaceBetween = isWeek;
        final barWidget = Row(
          mainAxisAlignment: useSpaceBetween ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(count, (i) {
            final raw = heights.length > i ? heights[i] : 0;
            final h = raw < AppDimensions.chartBarMinValue
                ? AppDimensions.chartBarMinValue
                : raw;
            return Container(
              width: AppDimensions.chartBarWidth,
              margin: isWeek ? null : EdgeInsets.only(right: i < count - 1 ? AppDimensions.spacingSm : 0),
              height: h * DemoConstants.chartBarHeightMultiplier,
              decoration: BoxDecoration(
                color:
                    (isDark
                            ? AppColors.primaryAccent
                            : AppColors.lightPrimaryAccent)
                        .withValues(alpha: h > DemoConstants.chartBarHighOpacityThreshold ? 1.0 : AppDimensions.chartBarOpacityLow),
                borderRadius: BorderRadius.circular(AppDimensions.chartBarRadius),
              ),
            );
          }),
        );
        final labelsRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (i) {
            return Padding(
              padding: isWeek ? EdgeInsets.zero : EdgeInsets.only(right: i < count - 1 ? AppDimensions.spacingSm : 0),
              child: SizedBox(
                width: AppDimensions.chartBarWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    labels.length > i ? labels[i] : '',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.secondaryText
                          : AppColors.lightSecondaryText,
                      fontSize: AppDimensions.fontSizeXxs,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            );
          }),
        );
        final chartContent = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: AppDimensions.chartHeight,
              child: barWidget,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            labelsRow,
          ],
        );
        final chartContentWithPadding = Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
          child: chartContent,
        );
        final chartContentHeight = AppDimensions.consistencyChartContentHeight;
        Widget monthChild;
        if (stats.consistencyBarHeightsMonth.length >= 13 &&
            stats.consistencyMonthLabels.length >= 13) {
          monthChild = Semantics(
            label: 'Consistency by month. Swipe for first 7 months, then next 6 including January next year.',
            child: SizedBox(
              height: chartContentHeight,
              child: PageView(
                children: [
                  _buildMonthChartPage(stats, isDark, 0, 7),
                  _buildMonthChartPage(stats, isDark, 7, 13),
                ],
              ),
            ),
          );
        } else {
          monthChild = Semantics(
            label: 'Consistency by month.',
            child: chartContent,
          );
        }
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
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isConsistencyWeek = true),
                        child: ToggleItem(
                            text: 'W', isSelected: _isConsistencyWeek),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isConsistencyWeek = false),
                        child: ToggleItem(
                            text: 'M', isSelected: !_isConsistencyWeek),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            CustomCard(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: SizedBox(
                height: chartContentHeight,
                child: isWeek ? chartContentWithPadding : monthChild,
              ),
            ),
          ],
        );
      },
    );
  }

  /// One page of the month chart: bars and labels for indices [start, end). Uses spaceBetween so 7 or 6 items fit without wrapping.
  Widget _buildMonthChartPage(
    StatisticsResult stats,
    bool isDark,
    int start,
    int end,
  ) {
    final heights = stats.consistencyBarHeightsMonth;
    final labels = stats.consistencyMonthLabels;
    final count = end - start;
    final barWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(count, (i) {
        final idx = start + i;
        final raw = heights.length > idx ? heights[idx] : 0;
        final h = raw < AppDimensions.chartBarMinValue
            ? AppDimensions.chartBarMinValue
            : raw;
        return Container(
          width: AppDimensions.chartBarWidth,
          height: h * DemoConstants.chartBarHeightMultiplier,
          decoration: BoxDecoration(
            color:
                (isDark
                        ? AppColors.primaryAccent
                        : AppColors.lightPrimaryAccent)
                    .withValues(alpha: h > DemoConstants.chartBarHighOpacityThreshold ? 1.0 : AppDimensions.chartBarOpacityLow),
            borderRadius: BorderRadius.circular(AppDimensions.chartBarRadius),
          ),
        );
      }),
    );
    final labelsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (i) {
        final idx = start + i;
        return SizedBox(
          width: AppDimensions.chartBarWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              labels.length > idx ? labels[idx] : '',
              style: TextStyle(
                color: isDark
                    ? AppColors.secondaryText
                    : AppColors.lightSecondaryText,
                fontSize: AppDimensions.fontSizeXxs,
              ),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      }),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.chartHeight, child: barWidget),
          const SizedBox(height: AppDimensions.spacingMd),
          labelsRow,
        ],
      ),
    );
  }

  Widget _buildInsightCard(StatisticsResult stats) {
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
                      stats.insightMessage,
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
