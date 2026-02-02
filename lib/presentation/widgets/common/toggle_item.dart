import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.toggleHorizontalPadding, vertical: AppDimensions.toggleVerticalPadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryText.withValues(alpha: AppDimensions.opacityXs)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.toggleRadius),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.primaryText : AppColors.secondaryText,
            fontSize: AppDimensions.fontSizeXxs,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
