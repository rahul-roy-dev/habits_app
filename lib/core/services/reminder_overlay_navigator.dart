import 'package:habits_app/domain/entities/habit_entity.dart';

abstract class ReminderOverlayNavigator {
  /// Pushes the reminder overlay route. [onPopped] is called when the overlay is closed.
  /// [habit] when non-null (e.g. loaded from Firestore on cold start) avoids an empty UI while Riverpod hydrates.
  void pushReminderOverlay({
    required String habitId,
    required String? reminderSlotKey,
    HabitEntity? habit,
    void Function()? onPopped,
  });
}
