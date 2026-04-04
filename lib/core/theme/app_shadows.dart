import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

/// Shared drop shadows used by cards (matches [CustomCard] with shadow).
abstract final class AppShadows {
  static List<BoxShadow> cardDrop() => [
        BoxShadow(
          color: Colors.black.withValues(alpha: AppDimensions.opacitySm),
          blurRadius: AppDimensions.shadowBlurMd,
          spreadRadius: 0.5,
          offset: const Offset(0, AppDimensions.shadowOffsetY),
        ),
      ];
}
