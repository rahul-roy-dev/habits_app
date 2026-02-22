import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';

/// Use case for signing in with Google (single responsibility).
class SignInWithGoogleUseCase {
  final IAuthenticator _authenticator;

  SignInWithGoogleUseCase(this._authenticator);

  Future<UserEntity?> execute() async {
    return _authenticator.signInWithGoogle();
  }
}
