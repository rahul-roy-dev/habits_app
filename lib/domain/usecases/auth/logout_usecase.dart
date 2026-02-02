import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';

/// Use case for user logout
class LogoutUseCase {
  final IAuthenticator _authenticator;

  LogoutUseCase(this._authenticator);


  Future<void> execute() async {
    await _authenticator.logout();
  }
}
