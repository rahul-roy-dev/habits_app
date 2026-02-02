import 'package:habits_app/domain/repositories/auth/i_user_registration.dart';

/// Use case for user registration
class RegisterUseCase {
  final IUserRegistration _userRegistration;

  RegisterUseCase(this._userRegistration);

  Future<bool> execute(String name, String email, String password) async {
    return await _userRegistration.register(name, email, password);
  }
}
