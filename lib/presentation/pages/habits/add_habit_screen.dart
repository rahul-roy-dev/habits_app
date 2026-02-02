import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/presentation/widgets/common/custom_button.dart';
import 'package:habits_app/presentation/widgets/common/custom_card.dart';
import 'package:habits_app/presentation/widgets/common/custom_input.dart';
import 'package:habits_app/presentation/widgets/common/custom_icon_button.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/presentation/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/presentation/widgets/common/frequency_toggle.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:habits_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/core/constants/app_strings.dart';

class AddHabitScreen extends StatefulWidget {
  final HabitEntity? habit;
  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late final TextEditingController _nameController;
  final _habitViewModel = sl<HabitViewModel>();
  final _authViewModel = sl<AuthViewModel>();
  late String _selectedIcon;
  late int _selectedColor;
  late String _frequency;
  final List<String> _selectedDays = AppValues.defaultSelectedDays;
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.title ?? '');
    _selectedIcon = widget.habit?.icon ?? 'water';
    _selectedColor = widget.habit?.color ?? AppValues.defaultHabitColor;
    _frequency = widget.habit?.description.split(' ').first ?? AppValues.defaultFrequency;
  }

  final List<Map<String, dynamic>> _icons = [
    {'name': 'workout', 'icon': Icons.fitness_center},
    {'name': 'water', 'icon': Icons.local_drink},
    {'name': 'book', 'icon': Icons.menu_book},
    {'name': 'meditation', 'icon': Icons.self_improvement},
    {'name': 'food', 'icon': Icons.restaurant},
    {'name': 'sleep', 'icon': Icons.nightlight_round},
    {'name': 'code', 'icon': Icons.code},
    {'name': 'other', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_nameController.text.isNotEmpty) {
      if (widget.habit != null) {
        final updatedHabit = widget.habit!.copyWith(
          title: _nameController.text.trim(),
          description: '$_frequency habit',
          icon: _selectedIcon,
          color: _selectedColor,
        );
        await _habitViewModel.updateHabit(widget.habit!.id, updatedHabit);
      } else {
        if (_authViewModel.isAuthenticated) {
          await _habitViewModel.addHabit(
            _nameController.text.trim(),
            '$_frequency habit',
            _selectedIcon,
            _selectedColor,
            _authViewModel.currentUser!.id,
          );
        }
      }
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  final isSelected = _selectedIcon == item['name'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = item['name']),
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
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
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
                        isSelected: _frequency == AppValues.frequencyDaily,
                        onTap: () => setState(() => _frequency = AppValues.frequencyDaily),
                      ),
                    ),
                    Expanded(
                      child: FrequencyToggle(
                        text: AppValues.frequencyWeekly,
                        isSelected: _frequency == AppValues.frequencyWeekly,
                        onTap: () => setState(() => _frequency = AppValues.frequencyWeekly),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: AppValues.daysOfWeek.map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.remove(day);
                        } else {
                          _selectedDays.add(day);
                        }
                      });
                    },
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
                        day,
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
                }).toList(),
              ),
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
                      value: _remindersEnabled,
                      onChanged: (v) => setState(() => _remindersEnabled = v),
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
