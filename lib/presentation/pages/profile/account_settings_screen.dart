import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/routes/app_routes.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/widgets/common/profile_menu_item.dart';
import 'package:habits_app/presentation/widgets/common/custom_icon_button.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/presentation/widgets/common/habits_app_bar.dart';

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HabitsAppBar(
        title: 'Account Settings',
        leading: Padding(
          padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
          child: CustomIconButton(
            icon: LucideIcons.chevron_left,
            onPressed: () => Navigator.pop(context),
            isActive: false,
          ),
        ),
      ),
       body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
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
                   fontSize: AppDimensions.fontSizeLg,
                ),
              ),
              onTap: null,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Update Password',
              onTap: () {},
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            ProfileMenuItem(
              icon: LucideIcons.globe,
              title: 'Connect with Google',
              onTap: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
               height: AppDimensions.buttonHeight,
              child: OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
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
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                     fontSize: AppDimensions.fontSizeXl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
             const SizedBox(height: AppDimensions.spacingXxxl),
          ],
        ),
      ),
    );
  }
}
