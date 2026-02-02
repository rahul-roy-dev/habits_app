import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final double size;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.size = AppDimensions.iconSizeSm,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? AppColors.primaryAccent.withValues(alpha: AppDimensions.opacitySm)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: size,
          color: isActive ? AppColors.primaryAccent : AppColors.secondaryText,
        ),
      ),
    );
  }
}
