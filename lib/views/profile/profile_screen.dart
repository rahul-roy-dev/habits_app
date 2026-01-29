import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/routes/app_routes.dart';
import 'package:habits_app/shared/widgets/custom_avatar.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/viewmodels/theme_viewmodel.dart';
import 'package:habits_app/shared/widgets/profile_menu_item.dart';
import 'package:habits_app/shared/widgets/custom_icon_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = sl<AuthViewModel>();
    final themeViewModel = sl<ThemeViewModel>();
    authViewModel.checkAuthStatus();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomIconButton(
            icon: LucideIcons.chevronLeft,
            onPressed: () => Navigator.pop(context),
            isActive: false,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: authViewModel,
        builder: (context, child) {
          final user = authViewModel.currentUser;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: CustomAvatar(
                    initials: user?.name.substring(0, 1) ?? 'U',
                    size: 100,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'User Name',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Account Settings',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.accountSettings),
                ),
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: themeViewModel,
                  builder: (context, _) {
                    return ProfileMenuItem(
                      icon: isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      title: isDark ? 'Dark Mode' : 'Light Mode',
                      trailing: Switch(
                        value: themeViewModel.isDarkMode,
                        onChanged: (value) => themeViewModel.toggleTheme(value),
                        activeThumbColor: AppColors.primaryAccent,
                        activeTrackColor: AppColors.primaryAccent.withValues(
                          alpha: 0.5,
                        ),
                        inactiveThumbColor: AppColors.primaryAccent,
                        inactiveTrackColor: AppColors.primaryAccent.withValues(
                          alpha: 0.3,
                        ),
                        trackOutlineColor: WidgetStateProperty.all(
                          AppColors.primaryAccentDark,
                        ),
                      ),
                      onTap: () => themeViewModel.toggleTheme(
                        !themeViewModel.isDarkMode,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                const Spacer(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
