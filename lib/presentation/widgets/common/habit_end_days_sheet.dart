import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_app/core/constants/achievement_sheet_dimensions.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_strings.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/common/app_modal_bottom_sheet.dart';
import 'package:habits_app/presentation/widgets/common/app_sheet_shell.dart';

/// iOS-style wheel for inclusive day count (start day counts as day 1).
Future<int?> showHabitEndDaysSheet(
  BuildContext context, {
  required int initialDays,
}) {
  return showAppModalBottomSheet<int>(
    context: context,
    isScrollControlled: false,
    showDragHandle: false,
    useSafeArea: false,
    builder: (ctx) => _HabitEndDaysSheetContent(initialDays: initialDays),
  );
}

class _HabitEndDaysSheetContent extends StatefulWidget {
  const _HabitEndDaysSheetContent({required this.initialDays});

  final int initialDays;

  @override
  State<_HabitEndDaysSheetContent> createState() => _HabitEndDaysSheetContentState();
}

class _HabitEndDaysSheetContentState extends State<_HabitEndDaysSheetContent> {
  late int _selected;
  late FixedExtentScrollController _controller;

  static int get _count =>
      AppValues.habitEndDaysMax - AppValues.habitEndDaysMin + 1;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDays.clamp(
      AppValues.habitEndDaysMin,
      AppValues.habitEndDaysMax,
    );
    _controller = FixedExtentScrollController(
      initialItem: _selected - AppValues.habitEndDaysMin,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark
        ? AppColors.secondaryText
        : AppColors.lightSecondaryText;
    final primary = isDark
        ? AppColors.primaryText
        : AppColors.lightPrimaryText;
    final bg = isDark ? AppColors.surface : AppColors.lightSurface;

    return AppSheetShell(
      wrapInScrollView: false,
      backgroundColor: bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppSheetDragHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingSm,
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(color: secondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppStrings.habitEndDaysSheetTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppDimensions.fontSizeXl,
                      color: primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: Text(
                    AppStrings.done,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AchievementSheetDimensions.habitEndDaysPickerHeight,
            child: CupertinoPicker(
              backgroundColor: bg,
              scrollController: _controller,
              itemExtent: AchievementSheetDimensions.habitEndDaysPickerItemExtent,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selected = AppValues.habitEndDaysMin + index;
                });
              },
              children: List.generate(
                _count,
                (i) {
                  final value = AppValues.habitEndDaysMin + i;
                  return Center(
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeHuge,
                        color: primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
