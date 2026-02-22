import 'package:habits_app/domain/entities/user_entity.dart';

/// Interface for authentication operations (login/logout/sign-in with providers)
abstract class IAuthenticator {
  Future<UserEntity?> login(String email, String password);

  Future<UserEntity?> signInWithGoogle();

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}
