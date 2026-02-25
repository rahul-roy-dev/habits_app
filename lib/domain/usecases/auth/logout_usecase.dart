import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Use case for user logout
class LogoutUseCase extends NoParamsUseCase<void> {
  final IAuthenticator _authenticator;

  LogoutUseCase(this._authenticator);

  @override
  Future<void> call() async {
    await _authenticator.logout();
  }

  Future<void> execute() async {
    return await call();
  }
}
