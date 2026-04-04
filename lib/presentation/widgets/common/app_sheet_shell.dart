import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';

/// Rounded top sheet container with max height — shared by achievement sheets,
/// habit pickers, and other app modals for a consistent look (opaque surface).
///
/// Set [wrapInScrollView] to false for embedded scrollables (e.g. wheel pickers).
class AppSheetShell extends StatelessWidget {
  const AppSheetShell({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.wrapInScrollView = true,
  });

  final Color backgroundColor;
  final Widget child;

  /// When false, [child] is placed directly in padded body (no [SingleChildScrollView]).
  final bool wrapInScrollView;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final body = Padding(
      padding: EdgeInsets.fromLTRB(
        AchievementSheetDimensions.sheetHorizontalPadding,
        0,
        AchievementSheetDimensions.sheetHorizontalPadding,
        AchievementSheetDimensions.sheetBottomPadding + bottomInset,
      ),
      child: child,
    );

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height *
                AchievementSheetDimensions.sheetMaxHeightFraction,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AchievementSheetDimensions.sheetTopCornerRadius),
            ),
          ),
          child: SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: wrapInScrollView
                ? SingleChildScrollView(child: body)
                : body,
          ),
        ),
      ),
    );
  }
}
