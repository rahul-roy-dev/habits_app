import 'package:habits_app/domain/repositories/auth/i_user_registration.dart';
import 'package:habits_app/domain/usecases/base_usecase.dart';

/// Parameters for register use case
class RegisterParams {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

/// Use case for user registration
class RegisterUseCase extends BaseUseCase<bool, RegisterParams> {
  final IUserRegistration _userRegistration;

  RegisterUseCase(this._userRegistration);

  @override
  Future<bool> call(RegisterParams params) async {
    return await _userRegistration.register(
      params.name,
      params.email,
      params.password,
    );
  }

  Future<bool> execute(String name, String email, String password) async {
    return await call(
      RegisterParams(
        name: name,
        email: email,
        password: password,
      ),
    );
  }
}
