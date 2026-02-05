import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class LoadingAnimation extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingAnimation({
    super.key,
    this.size = AppDimensions.loadingAnimationSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.inkDrop(
      color: color ?? AppColors.primaryAccent,
      size: size,
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingAnimation(),
                if (loadingText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.spacingMd),
                    child: Text(
                      loadingText!,
                      style: TextStyle(
                        color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
                        fontSize: AppDimensions.fontSizeMd,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
