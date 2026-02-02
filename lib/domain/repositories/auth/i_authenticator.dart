import 'package:habits_app/domain/entities/user_entity.dart';

/// Interface for authentication operations (login/logout)
abstract class IAuthenticator {
  Future<UserEntity?> login(String email, String password);
  
  Future<void> logout();
  
  Future<UserEntity?> getCurrentUser();
}
