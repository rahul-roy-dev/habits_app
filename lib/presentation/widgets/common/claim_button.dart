import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

class ClaimButton extends StatelessWidget {
  final VoidCallback onTap;

  const ClaimButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'CLAIM REWARDS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
