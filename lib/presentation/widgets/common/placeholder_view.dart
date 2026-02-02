import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';

class PlaceholderView extends StatelessWidget {
  final String title;

  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title VIEW',
        style: const TextStyle(
          color: AppColors.secondaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
