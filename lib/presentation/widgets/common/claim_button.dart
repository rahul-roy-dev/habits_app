import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class ClaimButton extends StatelessWidget {
  final VoidCallback onTap;

  const ClaimButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingXs),
        decoration: BoxDecoration(
          color: AppColors.primaryAccent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        child: const Text(
          'CLAIM REWARDS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppDimensions.fontSizeSm,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
