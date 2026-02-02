import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Container(
          height: AppDimensions.menuItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark
                    ? AppColors.primaryAccent
                    : AppColors.lightPrimaryAccent,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Text(
                title,
                style: TextStyle(
                  color: isDark
                      ? AppColors.primaryText
                      : AppColors.lightPrimaryText,
                  fontSize: AppDimensions.fontSizeXl,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              trailing ??
                  (onTap != null
                      ? Icon(
                          Icons.arrow_forward_ios,
                          color: isDark
                              ? AppColors.secondaryText
                              : AppColors.lightSecondaryText,
                          size: AppDimensions.fontSizeXl,
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
