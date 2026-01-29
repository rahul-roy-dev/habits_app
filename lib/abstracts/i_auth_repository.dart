import 'package:habits_app/data/models/user_model.dart';

abstract class IAuthRepository {
  Future<void> init();
  Future<bool> register(String name, String email, String password);
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
}
