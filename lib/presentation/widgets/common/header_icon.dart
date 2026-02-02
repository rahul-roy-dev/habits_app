import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

class HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const HeaderIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryAccent, size: 20),
      ),
    );
  }
}
