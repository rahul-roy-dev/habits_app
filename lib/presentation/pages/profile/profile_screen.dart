import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/widgets/common/custom_avatar.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:habits_app/presentation/widgets/common/profile_menu_item.dart';
import 'package:habits_app/presentation/widgets/common/custom_icon_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final authViewModel = sl<AuthViewModel>();
  late final themeViewModel = sl<ThemeViewModel>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
           padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
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
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.spacingLg),
                Center(
                  child: CustomAvatar(
                    initials: user?.name.substring(0, 1) ?? 'U',
                    size: AppDimensions.avatarSizeXl,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  user?.name ?? 'User Name',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText,
                     fontSize: AppDimensions.fontSizeHuge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXxxl),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Account Settings',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.accountSettings),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
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
                          alpha: AppDimensions.opacityMd,
                        ),
                        inactiveThumbColor: AppColors.primaryAccent,
                        inactiveTrackColor: AppColors.primaryAccent.withValues(
                          alpha: AppDimensions.opacityMd,
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
                const SizedBox(height: AppDimensions.spacingSm),
                ProfileMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Notifications',
                  onTap: () {},
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                ProfileMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  onTap: () {},
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                const Spacer(),
                const SizedBox(height: AppDimensions.spacingLg),
              ],
            ),
          );
        },
      ),
    );
  }
}
