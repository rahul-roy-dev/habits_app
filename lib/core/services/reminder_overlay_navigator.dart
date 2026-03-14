abstract class ReminderOverlayNavigator {
  /// Pushes the reminder overlay route. [onPopped] is called when the overlay is closed.
  void pushReminderOverlay({
    required String habitId,
    required String? reminderSlotKey,
    void Function()? onPopped,
  });
}
