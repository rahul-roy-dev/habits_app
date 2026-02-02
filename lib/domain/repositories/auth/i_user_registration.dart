/// Interface for user registration operations
abstract class IUserRegistration {
  Future<bool> register(String name, String email, String password);
}
