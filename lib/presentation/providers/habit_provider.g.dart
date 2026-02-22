// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Habit)
const habitProvider = HabitProvider._();

final class HabitProvider extends $NotifierProvider<Habit, HabitState> {
  const HabitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitHash();

  @$internal
  @override
  Habit create() => Habit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HabitState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HabitState>(value),
    );
  }
}

String _$habitHash() => r'8671499ff4d5179e2f4673a17b12555d78701298';

abstract class _$Habit extends $Notifier<HabitState> {
  HabitState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<HabitState, HabitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HabitState, HabitState>,
              HabitState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(totalHabits)
const totalHabitsProvider = TotalHabitsProvider._();

final class TotalHabitsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const TotalHabitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalHabitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalHabitsHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalHabits(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalHabitsHash() => r'3a46f1cb3d027a803403f7a8829cc8c89266b9b7';

@ProviderFor(habitCompletionProgress)
const habitCompletionProgressProvider = HabitCompletionProgressFamily._();

final class HabitCompletionProgressProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  const HabitCompletionProgressProvider._({
    required HabitCompletionProgressFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'habitCompletionProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitCompletionProgressHash();

  @override
  String toString() {
    return r'habitCompletionProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as DateTime;
    return habitCompletionProgress(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HabitCompletionProgressProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitCompletionProgressHash() =>
    r'4b338332e4d09b5385109ca158abad062d5e023e';

final class HabitCompletionProgressFamily extends $Family
    with $FunctionalFamilyOverride<double, DateTime> {
  const HabitCompletionProgressFamily._()
    : super(
        retry: null,
        name: r'habitCompletionProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitCompletionProgressProvider call(DateTime date) =>
      HabitCompletionProgressProvider._(argument: date, from: this);

  @override
  String toString() => r'habitCompletionProgressProvider';
}

@ProviderFor(isHabitCompleted)
const isHabitCompletedProvider = IsHabitCompletedFamily._();

final class IsHabitCompletedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsHabitCompletedProvider._({
    required IsHabitCompletedFamily super.from,
    required ({HabitEntity habit, DateTime date}) super.argument,
  }) : super(
         retry: null,
         name: r'isHabitCompletedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isHabitCompletedHash();

  @override
  String toString() {
    return r'isHabitCompletedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as ({HabitEntity habit, DateTime date});
    return isHabitCompleted(ref, habit: argument.habit, date: argument.date);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsHabitCompletedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isHabitCompletedHash() => r'694137fb0562c366d3664a75ff02556461decbc6';

final class IsHabitCompletedFamily extends $Family
    with $FunctionalFamilyOverride<bool, ({HabitEntity habit, DateTime date})> {
  const IsHabitCompletedFamily._()
    : super(
        retry: null,
        name: r'isHabitCompletedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsHabitCompletedProvider call({
    required HabitEntity habit,
    required DateTime date,
  }) => IsHabitCompletedProvider._(
    argument: (habit: habit, date: date),
    from: this,
  );

  @override
  String toString() => r'isHabitCompletedProvider';
}

@ProviderFor(completedHabitsCount)
const completedHabitsCountProvider = CompletedHabitsCountFamily._();

final class CompletedHabitsCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const CompletedHabitsCountProvider._({
    required CompletedHabitsCountFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'completedHabitsCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completedHabitsCountHash();

  @override
  String toString() {
    return r'completedHabitsCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as DateTime;
    return completedHabitsCount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedHabitsCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completedHabitsCountHash() =>
    r'db55ba248fcf82b7315b6835daaf46c3fb4a80ef';

final class CompletedHabitsCountFamily extends $Family
    with $FunctionalFamilyOverride<int, DateTime> {
  const CompletedHabitsCountFamily._()
    : super(
        retry: null,
        name: r'completedHabitsCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompletedHabitsCountProvider call(DateTime date) =>
      CompletedHabitsCountProvider._(argument: date, from: this);

  @override
  String toString() => r'completedHabitsCountProvider';
}
