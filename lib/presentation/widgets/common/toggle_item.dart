import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

class ToggleItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const ToggleItem({
    super.key,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryText.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.primaryText : AppColors.secondaryText,
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
