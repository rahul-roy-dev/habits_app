import 'package:habits_app/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<void> init();
  Future<bool> register(String name, String email, String password);
  Future<UserEntity?> login(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String userId);
}
