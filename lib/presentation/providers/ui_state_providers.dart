import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_providers.g.dart';

@riverpod
class PasswordVisibility extends _$PasswordVisibility {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

@riverpod
class RegisterPasswordVisibility extends _$RegisterPasswordVisibility {
  @override
  bool build() => true;

  void toggle() => state = !state;
}
