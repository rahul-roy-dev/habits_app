import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.black,
        onSecondary: AppColors.black,
        onSurface: AppColors.primaryText,
        onError: AppColors.primaryText,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppDimensions.fontSizeMassive,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppDimensions.fontSizeHuge,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppDimensions.fontSizeXxxl,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.primaryText,
          fontSize: AppDimensions.fontSizeXl,
        ),
        bodyMedium: TextStyle(
          color: AppColors.secondaryText,
          fontSize: AppDimensions.fontSizeLg,
        ),
      ),
      cardTheme: const CardThemeData(color: AppColors.surface, elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.primaryAccent,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.secondaryText),
        labelStyle: const TextStyle(color: AppColors.secondaryText),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryAccent.withValues(
          alpha: AppDimensions.opacitySm,
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryAccent);
          }
          return const IconThemeData(color: AppColors.secondaryText);
        }),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimaryAccent,
        secondary: AppColors.lightSuccess,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.lightPrimaryText,
        onError: AppColors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.lightPrimaryText,
          fontSize: AppDimensions.fontSizeMassive,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightPrimaryText,
          fontSize: AppDimensions.fontSizeHuge,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightPrimaryText,
          fontSize: AppDimensions.fontSizeXxxl,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.lightPrimaryText,
          fontSize: AppDimensions.fontSizeXl,
        ),
        bodyMedium: TextStyle(
          color: AppColors.lightSecondaryText,
          fontSize: AppDimensions.fontSizeLg,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(
            color: AppColors.lightPrimaryAccent,
            width: AppDimensions.borderWidthThin,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.lightSecondaryText),
        labelStyle: const TextStyle(color: AppColors.lightSecondaryText),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.lightPrimaryAccent.withValues(
          alpha: AppDimensions.opacitySm,
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.lightPrimaryAccent);
          }
          return const IconThemeData(color: AppColors.lightSecondaryText);
        }),
      ),
    );
  }
}
