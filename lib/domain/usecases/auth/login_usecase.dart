import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for login use case
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case for user login
class LoginUseCase extends BaseUseCase<UserEntity?, LoginParams> {
  final IAuthenticator _authenticator;

  LoginUseCase(this._authenticator);

  @override
  Future<UserEntity?> call(LoginParams params) async {
    return await _authenticator.login(params.email, params.password);
  }

  Future<UserEntity?> execute(String email, String password) async {
    return await call(LoginParams(email: email, password: password));
  }
}
