// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HabitForm)
const habitFormProvider = HabitFormFamily._();

final class HabitFormProvider
    extends $NotifierProvider<HabitForm, HabitFormState> {
  const HabitFormProvider._({
    required HabitFormFamily super.from,
    required HabitEntity? super.argument,
  }) : super(
         retry: null,
         name: r'habitFormProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitFormHash();

  @override
  String toString() {
    return r'habitFormProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HabitForm create() => HabitForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HabitFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HabitFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HabitFormProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitFormHash() => r'dde6835b3c9164689032e07ebc63877692d453fb';

final class HabitFormFamily extends $Family
    with
        $ClassFamilyOverride<
          HabitForm,
          HabitFormState,
          HabitFormState,
          HabitFormState,
          HabitEntity?
        > {
  const HabitFormFamily._()
    : super(
        retry: null,
        name: r'habitFormProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitFormProvider call(HabitEntity? initialHabit) =>
      HabitFormProvider._(argument: initialHabit, from: this);

  @override
  String toString() => r'habitFormProvider';
}

abstract class _$HabitForm extends $Notifier<HabitFormState> {
  late final _$args = ref.$arg as HabitEntity?;
  HabitEntity? get initialHabit => _$args;

  HabitFormState build(HabitEntity? initialHabit);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<HabitFormState, HabitFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HabitFormState, HabitFormState>,
              HabitFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
