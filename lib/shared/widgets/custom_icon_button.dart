import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

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
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? AppColors.primaryAccent.withValues(alpha: 0.2)
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
