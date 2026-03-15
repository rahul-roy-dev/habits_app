class HabitNameValidator {
  HabitNameValidator._();

  static bool isValid(String? name) {
    if (name == null) return false;
    return name.trim().isNotEmpty;
  }

  static String? validate(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Habit name is required';
    }
    return null;
  }
}
