import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/routes/app_routes.dart';
import 'package:habits_app/shared/widgets/custom_card.dart';
import 'package:habits_app/shared/widgets/custom_avatar.dart';
import 'package:habits_app/shared/widgets/placeholder_view.dart';
import 'package:habits_app/shared/widgets/header_icon.dart';
import 'package:habits_app/shared/widgets/date_item.dart';
import 'package:habits_app/shared/widgets/claim_button.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/views/statistics/statistics_screen.dart';
import 'package:habits_app/views/profile/profile_screen.dart';
import 'package:habits_app/shared/widgets/base_dialog.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _habitViewModel = sl<HabitViewModel>();
  final _authViewModel = sl<AuthViewModel>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initData();
  }

  Future<void> _initData() async {
    await _authViewModel.checkAuthStatus();
    if (_authViewModel.isAuthenticated) {
      _habitViewModel.loadHabits(_authViewModel.currentUser!.id);
    }
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
    final activeItemColor = AppColors.primaryAccent;
    final inactiveItemColor = isDark
        ? AppColors.secondaryText
        : AppColors.lightSecondaryText;

    return Scaffold(
      body: BottomBar(
        fit: StackFit.expand,
        icon: null,
        borderRadius: BorderRadius.zero,
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.92,
        barColor: Colors.transparent,
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
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
              habitViewModel: _habitViewModel,
              authViewModel: _authViewModel,
              controller: controller,
            ),
            StatisticsScreen(scrollController: controller),
            const SizedBox.shrink(),
            const PlaceholderView(title: 'SOCIAL'),
            const ProfileScreen(),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.grid_view, size: 26), text: 'Home'),
                  Tab(icon: Icon(Icons.trending_up, size: 26), text: 'Trends'),
                  SizedBox(width: 50),
                  Tab(
                    icon: Icon(Icons.people_outline, size: 26),
                    text: 'Social',
                  ),
                  Tab(
                    icon: Icon(Icons.settings_outlined, size: 26),
                    text: 'Settings',
                  ),
                ],
              ),
            ),

            Positioned(
              top: -20,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addHabit).then((_) {
                      if (_authViewModel.isAuthenticated) {
                        _habitViewModel.loadHabits(
                          _authViewModel.currentUser!.id,
                        );
                      }
                    }),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryAccent.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: barColor, width: 4),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final HabitViewModel habitViewModel;
  final AuthViewModel authViewModel;
  final ScrollController? controller;

  const _DashboardTab({
    required this.habitViewModel,
    required this.authViewModel,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: habitViewModel,
      builder: (context, child) {
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateStrip(context),
                    const SizedBox(height: 24),
                    _buildProgressCard(context),
                    const SizedBox(height: 30),
                    _buildHabitListHeader(context),
                    const SizedBox(height: 8),
                    _buildHabitList(context),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final user = authViewModel.currentUser;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                CustomAvatar(
                  initials: user?.name.substring(0, 1) ?? 'U',
                  size: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GOOD MORNING,',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.name ?? 'Alex Rivera',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                HeaderIcon(icon: Icons.bar_chart_outlined, onTap: () {}),
                const SizedBox(width: 12),
                const HeaderIcon(icon: Icons.notifications_none),
              ],
            ),
          ),
        );
      },
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Today',
              style: TextStyle(
                color: isDark
                    ? AppColors.primaryAccent
                    : AppColors.lightPrimaryAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = now.subtract(Duration(days: 3 - index));
              final isToday = date.day == now.day && date.month == now.month;
              return DateItem(date: date, isToday: isToday);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = habitViewModel.getCompletionProgress(DateTime.now());
    final total = habitViewModel.totalHabits;
    final completed = habitViewModel.getCompletedCount(DateTime.now());

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TODAY'S PROGRESS",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryAccent
                        : AppColors.lightPrimaryAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed < total
                      ? "Excellent! Only ${total - completed} habits remaining for a perfect day."
                      : "Amazing! You've completed all your habits for today!",
                  style: TextStyle(
                    color: isDark
                        ? AppColors.secondaryText
                        : AppColors.lightSecondaryText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ClaimButton(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor:
                      (isDark
                              ? AppColors.primaryAccent
                              : AppColors.lightPrimaryAccent)
                          .withValues(alpha: 0.1),
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
                  fontSize: 18,
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
          'Active Habits',
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          DateFormat('MMMM dd').format(DateTime.now()),
          style: TextStyle(
            color: isDark
                ? AppColors.secondaryText
                : AppColors.lightSecondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHabitList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final habits = habitViewModel.habits;
    if (habits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'No habits yet. Tap + to add one!',
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
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final isCompleted = habit.completionDates.any(
          (d) =>
              d.year == DateTime.now().year &&
              d.month == DateTime.now().month &&
              d.day == DateTime.now().day,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Dismissible(
            key: ValueKey(habit.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await BaseDialog.show(
                context: context,
                title: 'Delete Habit',
                message: 'Are you sure you want to delete "${habit.title}"?',
                cancelText: 'Cancel',
                confirmText: 'Delete',
                isDestructive: true,
              );
            },
            onDismissed: (direction) {
              habitViewModel.deleteHabit(habit);
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: AppColors.error,
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(
                    context,
                    AppRoutes.addHabit,
                    arguments: habit,
                  ).then((_) {
                    if (authViewModel.isAuthenticated) {
                      habitViewModel.loadHabits(authViewModel.currentUser!.id);
                    }
                  }),
              child: CustomCard(
                borderRadius: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(habit.color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(habit.icon),
                        color: Color(habit.color),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                              fontSize: 16,
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
                              fontSize: 12,
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
                                  .withValues(alpha: 0.3),
                        size: 32,
                      ),
                      onPressed: () =>
                          habitViewModel.toggleHabit(habit, DateTime.now()),
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
    switch (name) {
      case 'water':
        return Icons.local_drink;
      case 'workout':
        return Icons.fitness_center;
      case 'book':
        return Icons.menu_book;
      case 'meditation':
        return Icons.self_improvement;
      default:
        return Icons.check;
    }
  }
}
