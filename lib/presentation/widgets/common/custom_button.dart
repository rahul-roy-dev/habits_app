import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColors.primaryAccent
              : AppColors.surface,
          foregroundColor: isPrimary ? AppColors.black : AppColors.primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: AppDimensions.loaderSize,
                width: AppDimensions.loaderSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.loaderStrokeWidth,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: AppDimensions.fontSizeXl,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? AppColors.white : AppColors.primaryText,
                ),
              ),
      ),
    );
  }
}
