/// Thrown when a habit document is not found
class HabitNotFoundException implements Exception {
  HabitNotFoundException([this.habitId]);

  final String? habitId;

  @override
  String toString() => habitId != null
      ? 'HabitNotFoundException: habit not found for id "$habitId"'
      : 'HabitNotFoundException: habit not found';
}
