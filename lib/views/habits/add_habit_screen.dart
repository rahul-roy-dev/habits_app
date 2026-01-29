import 'package:flutter/material.dart';
import 'package:habits_app/core/theme/app_colors.dart';
import 'package:habits_app/shared/widgets/custom_button.dart';
import 'package:habits_app/shared/widgets/custom_card.dart';
import 'package:habits_app/shared/widgets/custom_input.dart';
import 'package:habits_app/shared/widgets/custom_icon_button.dart';
import 'package:habits_app/core/di/service_locator.dart';
import 'package:habits_app/viewmodels/habit_viewmodel.dart';
import 'package:habits_app/shared/widgets/frequency_toggle.dart';
import 'package:habits_app/data/models/habit_model.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:habits_app/viewmodels/auth_viewmodel.dart';

class AddHabitScreen extends StatefulWidget {
  final HabitModel? habit;
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
  final List<String> _selectedDays = ['M', 'T', 'W', 'T', 'F'];
  bool _remindersEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.title ?? '');
    _selectedIcon = widget.habit?.icon ?? 'water';
    _selectedColor = widget.habit?.color ?? 0xFFA78BFA;
    _frequency = widget.habit?.description.split(' ').first ?? 'Daily';
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

  final List<int> _colors = [
    0xFFA78BFA,
    0xFF3B82F6,
    0xFF10B981,
    0xFFF59E0B,
    0xFFEF4444,
    0xFFEC4899,
    0xFF06B6D4,
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
        await _habitViewModel.updateHabit(widget.habit!.key, updatedHabit);
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
          padding: const EdgeInsets.only(left: 16),
          child: CustomIconButton(
            icon: LucideIcons.chevronLeft,
            onPressed: () => Navigator.pop(context),
            isActive: false,
          ),
        ),
        title: Text(
          widget.habit != null ? 'Edit Habit' : 'Create Habit',
          style: TextStyle(
            color: isDark ? AppColors.primaryText : AppColors.lightPrimaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                label: 'HABIT NAME',
                hint: 'e.g., Morning Yoga',
                controller: _nameController,
              ),
              const SizedBox(height: 30),
              Text(
                'CHOOSE ICON',
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
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
                        borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 30),
              Text(
                'CATEGORIZATION COLOR',
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: isDark ? Colors.white : Colors.black,
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'FREQUENCY',
                style: TextStyle(
                  color: isDark
                      ? AppColors.secondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FrequencyToggle(
                        text: 'Daily',
                        isSelected: _frequency == 'Daily',
                        onTap: () => setState(() => _frequency = 'Daily'),
                      ),
                    ),
                    Expanded(
                      child: FrequencyToggle(
                        text: 'Weekly',
                        isSelected: _frequency == 'Weekly',
                        onTap: () => setState(() => _frequency = 'Weekly'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
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
                      width: 38,
                      height: 38,
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
              const SizedBox(height: 30),
              CustomCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: isDark
                          ? AppColors.secondaryText
                          : AppColors.lightSecondaryText,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Reminders',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.primaryText
                            : AppColors.lightPrimaryText,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _remindersEnabled,
                      onChanged: (v) => setState(() => _remindersEnabled = v),
                      activeColor: AppColors.primaryAccent,
                      trackOutlineColor: MaterialStateProperty.all(
                        AppColors.primaryAccentDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: widget.habit != null ? 'Update Habit' : 'Save Habit',
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
