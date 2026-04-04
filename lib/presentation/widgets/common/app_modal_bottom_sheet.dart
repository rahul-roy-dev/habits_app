import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/presentation/widgets/achievements/sheet/achievement_sheet_theme.dart';

/// Shared [showModalBottomSheet] configuration: dimmed barrier, drag to dismiss,
/// tap outside dismisses (same as barrier tap).
Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = false,
  /// When false, the sheet can extend edge-to-edge (e.g. behind the home indicator);
  /// use inner [SafeArea]/padding in the sheet content instead.
  bool useSafeArea = true,
  double barrierOpacity = AppDimensions.modalBarrierOpacityDefault,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: barrierOpacity),
    builder: builder,
  );
}

/// Drag handle used by achievement-style sheets.
class AppSheetDragHandle extends StatelessWidget {
  const AppSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.spacingSm,
        bottom: AppDimensions.spacingMd,
      ),
      child: Center(
        child: Container(
          width: AppDimensions.modalDragHandleWidth,
          height: AppDimensions.modalDragHandleHeight,
          decoration: BoxDecoration(
            color: AchievementSheetTheme.handleColor(context),
            borderRadius:
                BorderRadius.circular(AppDimensions.modalDragHandleBorderRadius),
          ),
        ),
      ),
    );
  }
}
