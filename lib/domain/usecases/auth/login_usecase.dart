import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';

/// Use case for user login
class LoginUseCase {
  final IAuthenticator _authenticator;

  LoginUseCase(this._authenticator);

  Future<UserEntity?> execute(String email, String password) async {
    return await _authenticator.login(email, password);
  }
}
