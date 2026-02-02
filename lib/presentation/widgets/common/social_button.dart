import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

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
      height: AppDimensions.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: iconPath != null
            ? SvgPicture.asset(
                iconPath!,
                width: AppDimensions.socialIconSize,
                height: AppDimensions.socialIconSize,
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
            fontSize: AppDimensions.fontSizeXl,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? AppColors.transparent : AppColors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          backgroundColor: isDark
              ? AppColors.surface
              : AppColors.white,
          elevation: isDark ? AppDimensions.elevationNone : AppDimensions.elevationSm,
          shadowColor: Colors.black.withValues(alpha: AppDimensions.opacityXxs),
        ),
      ),
    );
  }
}
