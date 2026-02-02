import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final bool isDestructive;

  const BaseDialog({
    super.key,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    this.isDestructive = false,
  });

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelText,
    required String confirmText,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: AppDimensions.opacityHalf),
      builder: (context) => BaseDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: AppDimensions.elevationNone,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXxxl),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppDimensions.spacingXl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
              blurRadius: AppDimensions.spacingLg,
              offset: const Offset(0, AppDimensions.tabVerticalPadding),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXxxl,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.primaryText
                    : AppColors.lightPrimaryText,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.fontSizeXl,
                color: isDark
                    ? AppColors.secondaryText
                    : AppColors.lightSecondaryText,
                height: AppDimensions.lineHeight,
              ),
            ),
            const SizedBox(height: AppDimensions.fontSizeMassive),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.fontSizeLg),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXl,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.secondaryText
                            : AppColors.lightSecondaryText,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDestructive
                          ? AppColors.error
                          : AppColors.primaryAccent,
                      foregroundColor: Colors.white,
                      elevation: AppDimensions.elevationNone,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.fontSizeLg),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeXl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
