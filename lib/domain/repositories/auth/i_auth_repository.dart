import 'package:habits_app/domain/repositories/auth/i_authenticator.dart';
import 'package:habits_app/domain/repositories/auth/i_user_registration.dart';
import 'package:habits_app/domain/repositories/auth/i_user_manager.dart';

/// Combined interface for full auth repository operations
/// Composes all segregated interfaces for convenience when full access is needed
abstract class IAuthRepository implements IAuthenticator, IUserRegistration, IUserManager {
  Future<void> init();
}
