import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/custom_avatar.dart';
import 'package:habits_app/presentation/widgets/common/placeholder_view.dart';
import 'package:habits_app/presentation/widgets/common/header_icon.dart';
import 'package:habits_app/presentation/widgets/common/date_item.dart';
import 'package:habits_app/presentation/widgets/common/claim_button.dart';
import 'package:habits_app/presentation/providers/habit_provider.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/pages/statistics/statistics_screen.dart';
import 'package:habits_app/presentation/pages/profile/profile_screen.dart';
import 'package:habits_app/presentation/widgets/common/base_dialog.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'package:habits_app/core/constants/app_values.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AppDimensions.tabCount, vsync: this);
    _initData();
  }

  Future<void> _initData() async {
    await ref.read(authProvider.notifier).checkAuthStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final barColor = isDark ? AppColors.surface : AppColors.lightSurface;
    const activeItemColor = AppColors.primaryAccent;
    final inactiveItemColor = isDark
        ? AppColors.secondaryText
        : AppColors.lightSecondaryText;

    return Scaffold(
      body: BottomBar(
        fit: StackFit.expand,
        icon: null,
        borderRadius: BorderRadius.zero,
        duration: const Duration(milliseconds: AppDimensions.animationDurationMs),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * AppDimensions.bottomBarWidthRatio,
        barColor: Colors.transparent,
        start: AppDimensions.bottomBarStartIndex,
        end: AppDimensions.bottomBarEndIndex,
        offset: AppDimensions.bottomBarOffset,
        barAlignment: Alignment.bottomCenter,
        iconHeight: AppDimensions.iconSizeXl,
        iconWidth: AppDimensions.iconSizeXl,
        reverse: false,
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            _DashboardTab(
              controller: controller,
            ),
            StatisticsScreen(scrollController: controller),
            const SizedBox.shrink(),
            const PlaceholderView(title: AppStrings.social),
            const ProfileScreen(),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: AppDimensions.bottomBarHeight,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
                    blurRadius: AppDimensions.shadowBlurMd,
                    offset: const Offset(0, AppDimensions.shadowOffsetY),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(),
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: activeItemColor,
                unselectedLabelColor: inactiveItemColor,
                labelStyle: const TextStyle(
                  fontSize: AppDimensions.fontSizeXs,
                  fontWeight: FontWeight.w700,
                  height: AppDimensions.lineHeight,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.grid_view, size: AppDimensions.iconSizeMd), text: AppStrings.home),
                  Tab(icon: Icon(Icons.trending_up, size: AppDimensions.iconSizeMd), text: AppStrings.trends),
                  SizedBox(width: AppDimensions.fabSize),
                  Tab(
                    icon: Icon(Icons.people_outline, size: AppDimensions.iconSizeMd),
                    text: AppStrings.social,
                  ),
                  Tab(
                    icon: Icon(Icons.settings_outlined, size: AppDimensions.iconSizeMd),
                    text: AppStrings.settings,
                  ),
                ],
              ),
            ),

            Positioned(
              top: AppDimensions.fabOffset,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addHabit),
                child: Container(
                  width: AppDimensions.fabSize,
                  height: AppDimensions.fabSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: AppDimensions.opacityLg),
                        blurRadius: AppDimensions.shadowBlurMd,
                        offset: const Offset(0, AppDimensions.shadowOffsetYLarge),
                      ),
                    ],
                    border: Border.all(color: barColor, width: AppDimensions.fabBorderWidth),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: AppDimensions.iconSizeLg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  final ScrollController? controller;

  const _DashboardTab({
    this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildHeader(context, ref),
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateStrip(context),
                SizedBox(height: AppDimensions.spacingXxl),
                _buildProgressCard(context, ref),
                SizedBox(height: AppDimensions.spacingXxl),
                _buildHabitListHeader(context),
                SizedBox(height: AppDimensions.spacingXs),
                _buildHabitList(context, ref),
                SizedBox(height: AppDimensions.bottomScrollPadding),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg, vertical: AppDimensions.spacingSm),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CustomAvatar(
              initials: user?.name.substring(0, 1) ?? AppStrings.defaultUserInitial,
              size: AppDimensions.avatarSizeMd,
            ),
            SizedBox(width: AppDimensions.spacingSm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.goodMorning,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: AppDimensions.fontSizeXxs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.name ?? AppStrings.defaultUserName,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeXxl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            HeaderIcon(icon: Icons.bar_chart_outlined, onTap: () {}),
            SizedBox(width: AppDimensions.spacingSm),
            const HeaderIcon(icon: Icons.notifications_none),
          ],
        ),
      ),
    );
  }

  Widget _buildDateStrip(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              monthName,
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
                fontSize: AppDimensions.fontSizeXxxl,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.today,
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryAccent
                    : AppColors.lightPrimaryAccent,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacingMd),
        SizedBox(
          height: AppDimensions.dateStripHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppDimensions.daysToShow,
            itemBuilder: (context, index) {
              final date = now.subtract(Duration(days: AppDimensions.dateOffsetDays - index));
              final isToday = date.day == now.day && date.month == now.month;
              return DateItem(date: date, isToday: isToday);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    
    final progress = ref.watch(habitCompletionProgressProvider(now));
    final total = ref.watch(totalHabitsProvider);
    final completed = ref.watch(completedHabitsCountProvider(now));

    return CustomCard(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.todaysProgress,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryAccent
                        : AppColors.lightPrimaryAccent,
                    fontSize: AppDimensions.fontSizeXxs,
                    fontWeight: FontWeight.bold,
                    letterSpacing: AppDimensions.letterSpacing,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXs),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: AppDimensions.fontSizeMassive,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingXxs),
                Text(
                  completed < total
                      ? AppStrings.excellentRemaining.replaceAll('{count}', '${total - completed}')
                      : AppStrings.amazingCompleted,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: AppDimensions.fontSizeMd,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingMd),
                ClaimButton(onTap: () {}),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spacingLg),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: AppDimensions.progressIndicatorSize,
                width: AppDimensions.progressIndicatorSize,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: AppDimensions.progressStrokeWidth,
                  backgroundColor:
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
                          .withValues(alpha: AppDimensions.opacityXs),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark
                        ? AppColors.primaryAccent
                        : AppColors.lightPrimaryAccent,
                  ),
                ),
              ),
              Text(
                "$completed/$total",
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.fontSizeXxl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitListHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.activeHabits,
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontSize: AppDimensions.fontSizeXxxl,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          DateFormat('MMMM dd').format(DateTime.now()),
          style: TextStyle(
            color: isDark
                ? AppColors.secondaryText
                : AppColors.lightSecondaryText,
            fontSize: AppDimensions.fontSizeSm,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitList(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final habitState = ref.watch(habitProvider);
    final habits = habitState.habits;

    if (habits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: AppDimensions.spacingXxxl),
          child: Text(
            AppStrings.noHabitsYet,
            style: TextStyle(
              color: isDark
                  ? AppColors.secondaryText
                  : AppColors.lightSecondaryText,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacingSm),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final isCompleted = ref.watch(
            isHabitCompletedProvider(
              habit: habit,
              date: DateTime.now(),
            ),
          );

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: Dismissible(
            key: ValueKey(habit.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await BaseDialog.show(
                context: context,
                title: AppStrings.deleteHabit,
                message: AppStrings.deleteHabitConfirmation.replaceAll('{habit}', habit.title),
                cancelText: AppStrings.cancel,
                confirmText: AppStrings.delete,
                isDestructive: true,
              );
            },
            onDismissed: (direction) {
              ref.read(habitProvider.notifier).deleteHabit(habit);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppDimensions.spacingLg),
              color: AppColors.error,
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addHabit,
                    arguments: habit,
                  ),
              child: CustomCard(
                borderRadius: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingSm,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.tabVerticalPadding),
                      decoration: BoxDecoration(
                        color: Color(habit.color).withValues(alpha: AppDimensions.opacityXs),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Icon(
                        _getIconData(habit.icon),
                        color: Color(habit.color),
                        size: AppDimensions.iconSizeSm,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.primaryText
                                  : AppColors.lightPrimaryText,
                              fontSize: AppDimensions.fontSizeXl,
                              fontWeight: FontWeight.w600,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            habit.description,
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
                    IconButton(
                      icon: Icon(
                        isCompleted
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: isCompleted
                            ? AppColors.secondaryAccent
                            : (isDark
                                      ? AppColors.primaryText
                                      : AppColors.lightPrimaryText)
                                  .withValues(alpha: AppDimensions.opacityMd),
                        size: AppDimensions.iconSizeLg,
                      ),
                      onPressed: () =>
                          ref.read(habitProvider.notifier).toggleHabit(habit, DateTime.now()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String name) {
    return AppValues.habitIconMap[name] ?? Icons.check;
  }
}
