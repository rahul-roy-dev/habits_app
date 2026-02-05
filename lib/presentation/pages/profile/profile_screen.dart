import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/widgets/common/custom_avatar.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/providers/theme_provider.dart';
import 'package:habits_app/presentation/widgets/common/profile_menu_item.dart';
import 'package:habits_app/presentation/widgets/common/custom_icon_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final themeState = ref.watch(appThemeModeProvider);
    final user = authState.currentUser;
    final isDarkMode = themeState == ThemeMode.dark || (themeState == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);


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
      body: Padding(
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
            ProfileMenuItem(
              icon: isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: isDark ? 'Dark Mode' : 'Light Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => ref.read(appThemeModeProvider.notifier).toggleTheme(value),
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
              onTap: () => ref.read(appThemeModeProvider.notifier).toggleTheme(!isDarkMode),
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
      ),
    );
  }
}
