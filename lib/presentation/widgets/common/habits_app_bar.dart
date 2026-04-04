import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/theme/app_colors.dart';

/// Shared app bar: by default transparent, no elevation, bold title, centered text.
/// Set [backgroundColor] to match the scaffold when content should not show through while scrolling.
/// When only [actions] are provided (no [leading]), a left spacer keeps the title visually centered.
class HabitsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HabitsAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  /// When null, the bar is transparent. Use [Theme.of(context).scaffoldBackgroundColor] for a solid bar.
  final Color? backgroundColor;

  static const double _leadingWidth = 56;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasActions = actions != null && actions!.isNotEmpty;
    final balanceLeading =
        leading == null && hasActions ? const SizedBox(width: _leadingWidth) : null;
    final effectiveLeading = leading ?? balanceLeading;

    final opaque = backgroundColor != null;

    return AppBar(
      backgroundColor: opaque ? backgroundColor : Colors.transparent,
      surfaceTintColor: opaque ? Colors.transparent : null,
      elevation: AppDimensions.elevationNone,
      scrolledUnderElevation: AppDimensions.elevationNone,
      automaticallyImplyLeading: false,
      centerTitle: true,
      titleSpacing: AppDimensions.spacingLg,
      leading: effectiveLeading,
      leadingWidth: balanceLeading != null ? _leadingWidth : null,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.fontSizeXxl,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
