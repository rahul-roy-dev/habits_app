// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statistics)
const statisticsProvider = StatisticsProvider._();

final class StatisticsProvider
    extends
        $FunctionalProvider<
          StatisticsResult,
          StatisticsResult,
          StatisticsResult
        >
    with $Provider<StatisticsResult> {
  const StatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsHash();

  @$internal
  @override
  $ProviderElement<StatisticsResult> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StatisticsResult create(Ref ref) {
    return statistics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsResult value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsResult>(value),
    );
  }
}

String _$statisticsHash() => r'd83428e05677fcd154a905ff00c9f97a5cd98acc';
