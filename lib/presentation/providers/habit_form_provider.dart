import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';

part 'habit_form_provider.g.dart';

class HabitFormState {
  final String name;
  final String icon;
  final int color;
  final String frequency;
  /// Weekdays when habit appears (1=Mon .. 7=Sun). Only used when frequency is Weekly.
  final List<int> selectedWeekdays;
  final bool remindersEnabled;

  HabitFormState({
    this.name = '',
    this.icon = AppValues.defaultHabitIcon,
    this.color = AppValues.defaultHabitColor,
    this.frequency = AppValues.defaultFrequency,
    this.selectedWeekdays = AppValues.defaultSelectedWeekdayIndices,
    this.remindersEnabled = true,
  });

  HabitFormState copyWith({
    String? name,
    String? icon,
    int? color,
    String? frequency,
    List<int>? selectedWeekdays,
    bool? remindersEnabled,
  }) {
    return HabitFormState(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
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
        selectedWeekdays: initialHabit.selectedWeekdays.isNotEmpty
            ? List<int>.from(initialHabit.selectedWeekdays)
            : AppValues.defaultSelectedWeekdayIndices,
        remindersEnabled: true,
      );
    }
    return HabitFormState();
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateIcon(String icon) => state = state.copyWith(icon: icon);
  void updateColor(int color) => state = state.copyWith(color: color);
  void updateFrequency(String frequency) => state = state.copyWith(frequency: frequency);

  /// Toggle weekday (1=Mon .. 7=Sun). Only relevant when frequency is Weekly.
  void toggleWeekday(int weekday) {
    final list = List<int>.from(state.selectedWeekdays);
    if (list.contains(weekday)) {
      list.remove(weekday);
    } else {
      list.add(weekday);
    }
    list.sort();
    state = state.copyWith(selectedWeekdays: list);
  }

  void updateReminders(bool enabled) => state = state.copyWith(remindersEnabled: enabled);
}
