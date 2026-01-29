import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/routes/app_routes.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/shared/widgets/profile_menu_item.dart';
import 'package:habits_app/shared/widgets/custom_icon_button.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = sl<AuthViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = authViewModel.currentUser;

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
          'Account Settings',
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ProfileMenuItem(
              icon: Icons.email_outlined,
              title: 'Email',
              trailing: Text(
                user?.email ?? '',
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 14,
                ),
              ),
              onTap: null,
            ),
            const SizedBox(height: 12),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Update Password',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            ProfileMenuItem(
              icon: LucideIcons.globe,
              title: 'Connect with Google',
              onTap: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () async {
                  await authViewModel.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
