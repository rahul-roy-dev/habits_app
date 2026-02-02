import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String text;
  final VoidCallback onPressed;
  final Color? iconColor;

  const SocialButton({
    super.key,
    this.icon,
    this.iconPath,
    required this.text,
    required this.onPressed,
    this.iconColor,
  }) : assert(icon != null || iconPath != null);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: iconPath != null
            ? SvgPicture.asset(
                iconPath!,
                width: 24,
                height: 24,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
              )
            : Icon(
                icon,
                color: iconColor ??
                    (isDark
                        ? AppColors.primaryText
                        : AppColors.lightPrimaryText),
              ),
        label: Text(
          text,
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? AppColors.transparent : AppColors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark
              ? AppColors.surface
              : AppColors.white,
          elevation: isDark ? 0 : 2,
          shadowColor: Colors.black.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}
