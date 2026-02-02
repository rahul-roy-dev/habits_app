import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;

  const CustomAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = AppDimensions.avatarSizeDefault,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppColors.primaryAccent.withValues(alpha: AppDimensions.opacitySm),
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials.toUpperCase(),
              style: TextStyle(
                color: AppColors.primaryAccent,
                fontWeight: FontWeight.bold,
                fontSize: size * AppDimensions.opacityLg,
              ),
            )
          : null,
    );
  }
}
