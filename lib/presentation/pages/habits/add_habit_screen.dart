import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/custom_input.dart';
import 'package:habits_app/presentation/widgets/common/custom_icon_button.dart';
import 'package:habits_app/presentation/widgets/common/frequency_toggle.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:habits_app/presentation/providers/habit_provider.dart';
import 'package:habits_app/presentation/providers/auth_provider.dart';
import 'package:habits_app/presentation/providers/habit_form_provider.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/constants/app_strings.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final HabitEntity? habit;
  const AddHabitScreen({super.key, this.habit});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.title ?? '');
  }

  List<Map<String, dynamic>> get _icons => AppValues.habitIconMap.entries
      .map((entry) => {
            'name': entry.key,
            'icon': entry.value,
          })
      .toList();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final formState = ref.read(habitFormProvider(widget.habit));
    if (_nameController.text.isEmpty) return;
    final isWeekly = formState.frequency == AppValues.frequencyWeekly;
    final selectedWeekdays = isWeekly && formState.selectedWeekdays.isNotEmpty
        ? formState.selectedWeekdays
        : <int>[];

    if (widget.habit != null) {
      final existing = widget.habit!;
      final updatedHabit = existing.copyWith(
        title: _nameController.text.trim(),
        description: '${formState.frequency} habit',
        icon: formState.icon,
        color: formState.color,
        selectedWeekdays: selectedWeekdays,
      );
      await ref.read(habitProvider.notifier).updateHabit(widget.habit!.id, updatedHabit);
    } else {
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        await ref.read(habitProvider.notifier).addHabit(
          _nameController.text.trim(),
          '${formState.frequency} habit',
          formState.icon,
          formState.color,
          selectedWeekdays: selectedWeekdays,
        );
      }
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formState = ref.watch(habitFormProvider(widget.habit));
    final formNotifier = ref.read(habitFormProvider(widget.habit).notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppDimensions.spacingMd),
          child: CustomIconButton(
            icon: LucideIcons.chevronLeft,
            onPressed: () => Navigator.pop(context),
            isActive: false,
          ),
        ),
        title: Text(
          widget.habit != null ? AppStrings.editHabit : AppStrings.createHabit,
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                label: AppStrings.habitName,
                hint: AppStrings.habitNameHint,
                controller: _nameController,
                onChanged: formNotifier.updateName,
              ),
              SizedBox(height: AppDimensions.spacingXxl),
              Text(
                AppStrings.chooseIcon,
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: AppDimensions.fontSizeXxs,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacingMd),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppDimensions.gridCrossAxisCount,
                  mainAxisSpacing: AppDimensions.spacingSm,
                  crossAxisSpacing: AppDimensions.spacingSm,
                ),
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  final item = _icons[index];
                  final isSelected = formState.icon == item['name'];
                  return GestureDetector(
                    onTap: () => formNotifier.updateIcon(item['name']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryAccent
                            : (isDark
                                  ? AppColors.surface
                                  : AppColors.lightSurface),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      ),
                      child: Icon(
                        item['icon'],
                        color: isSelected
                            ? AppColors.white
                            : (isDark
                                  ? AppColors.secondaryText
                                  : AppColors.lightSecondaryText),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppDimensions.spacingXxl),
              Text(
                AppStrings.categorizationColor,
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: AppDimensions.fontSizeXxs,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacingMd),
              SizedBox(
                height: AppDimensions.cardHeightSm,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppValues.habitColors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingSm),
                  itemBuilder: (context, index) {
                    final color = AppValues.habitColors[index];
                    final isSelected = formState.color == color;
                    return GestureDetector(
                      onTap: () => formNotifier.updateColor(color),
                      child: Container(
                        width: AppDimensions.cardHeightSm,
                        height: AppDimensions.cardHeightSm,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: isDark ? Colors.white : Colors.black,
                                  width: AppDimensions.borderWidthMedium,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: AppDimensions.spacingXxl),
              Text(
                AppStrings.frequency,
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: AppDimensions.fontSizeXxs,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.spacingMd),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FrequencyToggle(
                        text: AppValues.frequencyDaily,
                        isSelected: formState.frequency == AppValues.frequencyDaily,
                        onTap: () => formNotifier.updateFrequency(AppValues.frequencyDaily),
                      ),
                    ),
                    Expanded(
                      child: FrequencyToggle(
                        text: AppValues.frequencyWeekly,
                        isSelected: formState.frequency == AppValues.frequencyWeekly,
                        onTap: () => formNotifier.updateFrequency(AppValues.frequencyWeekly),
                      ),
                    ),
                  ],
                ),
              ),
              if (formState.frequency == AppValues.frequencyWeekly) ...[
                SizedBox(height: AppDimensions.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(AppValues.daysInWeek, (index) {
                    final weekday = index + 1;
                    final isSelected = formState.selectedWeekdays.contains(weekday);
                    final label = AppValues.daysOfWeek[index];
                    return GestureDetector(
                      onTap: () => formNotifier.toggleWeekday(weekday),
                      child: Container(
                        width: AppDimensions.avatarSizeSm,
                        height: AppDimensions.avatarSizeSm,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : (isDark
                                    ? AppColors.surface
                                    : AppColors.lightSurface),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.white
                                : (isDark
                                      ? AppColors.secondaryText
                                      : AppColors.lightSecondaryText),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
              SizedBox(height: AppDimensions.spacingXxl),
              CustomCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingXs,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: isDark
                          ? AppColors.secondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    SizedBox(width: AppDimensions.spacingSm),
                    Text(
                      AppStrings.reminders,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                        fontSize: AppDimensions.fontSizeXl,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: formState.remindersEnabled,
                      onChanged: formNotifier.updateReminders,
                      activeTrackColor: AppColors.primaryAccent,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingXxl),
              CustomButton(
                text: widget.habit != null ? AppStrings.updateHabit : AppStrings.saveHabit,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
