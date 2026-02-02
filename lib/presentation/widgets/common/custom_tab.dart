import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const CustomTab({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.tabHorizontalPadding, vertical: AppDimensions.tabVerticalPadding),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? AppColors.black : AppColors.secondaryText,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
