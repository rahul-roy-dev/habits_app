import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool showShadow;
  final Color? color;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.showShadow = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.surface : AppColors.lightSurface),
        borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radiusMd),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
                  blurRadius: AppDimensions.shadowBlurSm,
                  offset: const Offset(0, AppDimensions.shadowOffsetY),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
