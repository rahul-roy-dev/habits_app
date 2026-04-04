import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';

part 'habit_form_provider.g.dart';

int _endAfterDaysFromHabit(HabitEntity h) {
  if (h.endAfterDays != null) return h.endAfterDays!;
  if (h.endDate == null) return AppValues.habitEndDaysDefault;
  final start = HabitEntity.normalizeDate(h.createdAt);
  final end = HabitEntity.normalizeDate(h.endDate!);
  return (end.difference(start).inDays + 1).clamp(
        AppValues.habitEndDaysMin,
        AppValues.habitEndDaysMax,
      );
}

class HabitFormState {
  final String name;
  final String icon;
  final int color;
  final String frequency;
  final List<int> selectedWeekdays;
  final bool remindersEnabled;
  final int? alertHour;
  final int? alertMinute;
  final HabitEndMode endMode;
  /// Last day when [endMode] is [HabitEndMode.onDate].
  final DateTime? endDate;
  /// Inclusive day count when [endMode] is [HabitEndMode.afterDays].
  final int endAfterDays;

  HabitFormState({
    this.name = '',
    this.icon = AppValues.defaultHabitIcon,
    this.color = AppValues.defaultHabitColor,
    this.frequency = AppValues.defaultFrequency,
    this.selectedWeekdays = AppValues.defaultSelectedWeekdayIndices,
    this.remindersEnabled = true,
    this.alertHour,
    this.alertMinute,
    this.endMode = HabitEndMode.none,
    this.endDate,
    this.endAfterDays = AppValues.habitEndDaysDefault,
  });

  HabitFormState copyWith({
    String? name,
    String? icon,
    int? color,
    String? frequency,
    List<int>? selectedWeekdays,
    bool? remindersEnabled,
    int? alertHour,
    int? alertMinute,
    bool clearAlertTime = false,
    HabitEndMode? endMode,
    DateTime? endDate,
    int? endAfterDays,
  }) {
    return HabitFormState(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      alertHour: clearAlertTime ? null : (alertHour ?? this.alertHour),
      alertMinute: clearAlertTime ? null : (alertMinute ?? this.alertMinute),
      endMode: endMode ?? this.endMode,
      endDate: endDate ?? this.endDate,
      endAfterDays: endAfterDays ?? this.endAfterDays,
    );
  }
}

@riverpod
class HabitForm extends _$HabitForm {
  @override
  HabitFormState build(HabitEntity? initialHabit) {
    if (initialHabit != null) {
      final endDateForForm = initialHabit.endMode == HabitEndMode.onDate
          ? (initialHabit.endDate ??
              HabitEntity.normalizeDate(DateTime.now()).add(
                Duration(days: AppValues.habitEndDaysDefault),
              ))
          : null;
      return HabitFormState(
        name: initialHabit.title,
        icon: initialHabit.icon,
        color: initialHabit.color,
        frequency: initialHabit.description.split(' ').first,
        selectedWeekdays: initialHabit.selectedWeekdays.isNotEmpty
            ? List<int>.from(initialHabit.selectedWeekdays)
            : AppValues.defaultSelectedWeekdayIndices,
        remindersEnabled: initialHabit.alertHour != null,
        alertHour: initialHabit.alertHour,
        alertMinute: initialHabit.alertMinute,
        endMode: initialHabit.endMode,
        endDate: endDateForForm != null
            ? HabitEntity.normalizeDate(endDateForForm)
            : null,
        endAfterDays: initialHabit.endMode == HabitEndMode.afterDays
            ? _endAfterDaysFromHabit(initialHabit)
            : AppValues.habitEndDaysDefault,
      );
    }
    return HabitFormState();
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateIcon(String icon) => state = state.copyWith(icon: icon);
  void updateColor(int color) => state = state.copyWith(color: color);
  void updateFrequency(String frequency) => state = state.copyWith(frequency: frequency);

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

  void updateReminders(bool enabled) {
    if (!enabled) {
      state = state.copyWith(remindersEnabled: enabled, clearAlertTime: true);
    } else {
      state = state.copyWith(remindersEnabled: enabled);
    }
  }

  void updateAlertTime(int hour, int minute) {
    state = state.copyWith(alertHour: hour, alertMinute: minute, remindersEnabled: true);
  }

  void clearAlertTime() {
    state = state.copyWith(clearAlertTime: true, remindersEnabled: false);
  }

  void updateEndMode(HabitEndMode mode) {
    DateTime? endDate = state.endDate;
    if (mode == HabitEndMode.onDate) {
      endDate ??= HabitEntity.normalizeDate(DateTime.now()).add(
        Duration(days: AppValues.habitEndDaysDefault),
      );
    } else if (mode == HabitEndMode.none) {
      endDate = null;
    }
    state = state.copyWith(endMode: mode, endDate: endDate);
  }

  void updateEndDate(DateTime date) {
    state = state.copyWith(endDate: HabitEntity.normalizeDate(date));
  }

  void updateEndAfterDays(int days) {
    state = state.copyWith(
      endAfterDays: days.clamp(
        AppValues.habitEndDaysMin,
        AppValues.habitEndDaysMax,
      ),
    );
  }
}
