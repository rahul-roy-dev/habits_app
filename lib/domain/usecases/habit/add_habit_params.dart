/// Parameters class for AddHabitUseCase
class AddHabitParams {
  final String title;
  final String description;
  final String icon;
  final int color;
  final String userId;

  const AddHabitParams({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.userId,
  });

  /// Validates the parameters
  void validate() {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    if (color < 0) {
      throw ArgumentError('Color must be a valid positive integer');
    }
  }
}
