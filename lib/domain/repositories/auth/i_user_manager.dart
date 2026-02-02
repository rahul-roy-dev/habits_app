import 'package:habits_app/domain/entities/user_entity.dart';

/// Interface for user management operations (update/delete)
abstract class IUserManager {
  Future<void> updateUser(UserEntity user);
  
  Future<void> deleteUser(String userId);
}
