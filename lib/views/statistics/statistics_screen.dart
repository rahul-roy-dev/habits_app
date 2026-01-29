import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/shared/widgets/custom_card.dart';
import 'package:habits_app/shared/widgets/custom_avatar.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/shared/widgets/stat_mini_card.dart';
import 'package:habits_app/shared/widgets/streak_card.dart';
import 'package:habits_app/shared/widgets/toggle_item.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';

class StatisticsScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const StatisticsScreen({super.key, this.scrollController});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _habitViewModel = sl<HabitViewModel>();
  final _authViewModel = sl<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _authViewModel.checkAuthStatus();
    if (_authViewModel.isAuthenticated) {
      _habitViewModel.loadHabits(_authViewModel.currentUser!.id);
    }
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
            padding: EdgeInsets.only(right: 16),
            child: CustomAvatar(initials: 'AR', size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(20),
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
                SizedBox(width: 16),
                Expanded(
                  child: StatMiniCard(title: 'BEST\nSTREAK', value: '24 Days'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildHeatmapSection(),
            const SizedBox(height: 30),
            Text(
              'Top Streaks',
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTopStreaks(),
            const SizedBox(height: 30),
            _buildConsistencySection(),
            const SizedBox(height: 30),
            _buildInsightCard(),
            const SizedBox(height: 30),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'OCT 14 - OCT 20',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                  final opacity =
                      (day == 'M' || day == 'W' || day == 'T' || day == 'S')
                      ? 0.8
                      : 0.1;
                  return Column(
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.primaryAccent
                                      : AppColors.lightPrimaryAccent)
                                  .withValues(alpha: opacity),
                          borderRadius: BorderRadius.circular(8),
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
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          StreakCard(
            title: 'MORNING YOGA',
            value: '12 Days',
            progress: 0.7,
            icon: Icons.wb_sunny_outlined,
          ),
          SizedBox(width: 16),
          StreakCard(
            title: 'HYDRATION',
            value: '8 Days',
            progress: 0.4,
            icon: Icons.local_drink,
          ),
          SizedBox(width: 16),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: 16),
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [60, 80, 70, 100, 75, 85, 40, 90, 100]
                          .map(
                            (h) => Container(
                              width: 20,
                              height: h * 1.5,
                              decoration: BoxDecoration(
                                color:
                                    (isDark
                                            ? AppColors.primaryAccent
                                            : AppColors.lightPrimaryAccent)
                                        .withValues(alpha: h > 80 ? 1.0 : 0.4),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MON',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'LIVE TREND',
                        style: TextStyle(
                          color:
                              (isDark
                                      ? AppColors.primaryText
                                      : AppColors.lightPrimaryText)
                                  .withValues(alpha: 0.5),
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'SUN',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          fontSize: 10,
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
              .withValues(alpha: 0.3),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isDark
                      ? AppColors.primaryAccent
                      : AppColors.lightPrimaryAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      "You're most productive during early hours. Try setting your high-effort habits before 9 AM for a 30% higher success rate.",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: 12,
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
