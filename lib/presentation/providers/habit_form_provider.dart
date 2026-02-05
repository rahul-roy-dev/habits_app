import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';

part 'habit_form_provider.g.dart';

class HabitFormState {
  final String name;
  final String icon;
  final int color;
  final String frequency;
  final List<String> selectedDays;
  final bool remindersEnabled;

  HabitFormState({
    this.name = '',
    this.icon = AppValues.defaultHabitIcon,
    this.color = AppValues.defaultHabitColor,
    this.frequency = AppValues.defaultFrequency,
    this.selectedDays = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.remindersEnabled = true,
  });

  HabitFormState copyWith({
    String? name,
    String? icon,
    int? color,
    String? frequency,
    List<String>? selectedDays,
    bool? remindersEnabled,
  }) {
    return HabitFormState(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }
}

@riverpod
class HabitForm extends _$HabitForm {
  @override
  HabitFormState build(HabitEntity? initialHabit) {
    if (initialHabit != null) {
      return HabitFormState(
        name: initialHabit.title,
        icon: initialHabit.icon,
        color: initialHabit.color,
        frequency: initialHabit.description.split(' ').first,
        selectedDays: List.from(AppValues.defaultSelectedDays), // Assuming default for now
        remindersEnabled: true,
      );
    }
    return HabitFormState();
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateIcon(String icon) => state = state.copyWith(icon: icon);
  void updateColor(int color) => state = state.copyWith(color: color);
  void updateFrequency(String frequency) => state = state.copyWith(frequency: frequency);
  
  void toggleDay(String day) {
    final newList = List<String>.from(state.selectedDays);
    if (newList.contains(day)) {
      newList.remove(day);
    } else {
      newList.add(day);
    }
    state = state.copyWith(selectedDays: newList);
  }

  void updateReminders(bool enabled) => state = state.copyWith(remindersEnabled: enabled);
}
