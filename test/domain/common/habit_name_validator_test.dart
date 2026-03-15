import 'package:flutter_test/flutter_test.dart';
import 'package:habits_app/domain/common/habit_name_validator.dart';

/// Unit tests for [HabitNameValidator].
/// Add new cases here when validation rules change (e.g. max length, sanitization).
void main() {
  group('HabitNameValidator.isValid', () {
    test('returns false for null', () {
      expect(HabitNameValidator.isValid(null), isFalse);
    });

    test('returns false for empty string', () {
      expect(HabitNameValidator.isValid(''), isFalse);
    });

    test('returns false for whitespace-only string', () {
      expect(HabitNameValidator.isValid('   '), isFalse);
      expect(HabitNameValidator.isValid('\t\n'), isFalse);
    });

    test('returns true for non-empty trimmed string', () {
      expect(HabitNameValidator.isValid('Read'), isTrue);
      expect(HabitNameValidator.isValid('  Read  '), isTrue);
    });
  });

  group('HabitNameValidator.validate', () {
    test('returns error message for null or empty', () {
      expect(HabitNameValidator.validate(null), equals('Habit name is required'));
      expect(HabitNameValidator.validate(''), equals('Habit name is required'));
      expect(HabitNameValidator.validate('   '), equals('Habit name is required'));
    });

    test('returns null for valid name', () {
      expect(HabitNameValidator.validate('Exercise'), isNull);
      expect(HabitNameValidator.validate('  Hydration  '), isNull);
    });
  });
}
