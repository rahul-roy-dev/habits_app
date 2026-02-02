import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase {
  final IAuthenticator _authenticator;

  GetCurrentUserUseCase(this._authenticator);

  
  Future<UserEntity?> execute() async {
    return await _authenticator.getCurrentUser();
  }
}
