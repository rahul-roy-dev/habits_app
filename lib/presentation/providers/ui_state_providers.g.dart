// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PasswordVisibility)
const passwordVisibilityProvider = PasswordVisibilityProvider._();

final class PasswordVisibilityProvider
    extends $NotifierProvider<PasswordVisibility, bool> {
  const PasswordVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordVisibilityHash();

  @$internal
  @override
  PasswordVisibility create() => PasswordVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordVisibilityHash() =>
    r'8a2d21ab7922dad28114fb011f130dbeafcee17a';

abstract class _$PasswordVisibility extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RegisterPasswordVisibility)
const registerPasswordVisibilityProvider =
    RegisterPasswordVisibilityProvider._();

final class RegisterPasswordVisibilityProvider
    extends $NotifierProvider<RegisterPasswordVisibility, bool> {
  const RegisterPasswordVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerPasswordVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerPasswordVisibilityHash();

  @$internal
  @override
  RegisterPasswordVisibility create() => RegisterPasswordVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$registerPasswordVisibilityHash() =>
    r'bb674dd2ffb8bd408604a2a5acf433fccdcc1886';

abstract class _$RegisterPasswordVisibility extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
