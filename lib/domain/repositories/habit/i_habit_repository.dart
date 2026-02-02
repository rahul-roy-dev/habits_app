import 'package:habits_app/domain/repositories/habit/i_habit_reader.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_writer.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_completion.dart';

/// Combined interface for full habit repository operations
/// Composes all segregated interfaces for convenience when full access is needed
abstract class IHabitRepository implements IHabitReader, IHabitWriter, IHabitCompletion {
  Future<void> init();
}
