import 'package:flutter/material.dart';
import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/usecases/auth/login_usecase.dart';
import 'package:habits_app/domain/usecases/auth/logout_usecase.dart';
import 'package:habits_app/domain/usecases/auth/register_usecase.dart';
import 'package:habits_app/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:habits_app/domain/repositories/auth/i_user_manager.dart';
import 'package:habits_app/core/constants/app_strings.dart';

/// ViewModel for managing authentication-related UI state
/// Follows Clean Architecture by depending on Use Cases, not Repositories
class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IUserManager _userManager;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required IUserManager userManager,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _registerUseCase = registerUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _userManager = userManager;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _currentUser = await _getCurrentUserUseCase.execute();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    _currentUser = await _loginUseCase.execute(email, password);

    if (_currentUser == null) {
      _errorMessage = AppStrings.invalidEmailOrPassword;
    }

    _setLoading(false);
    return _currentUser != null;
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _registerUseCase.execute(name, email, password);

    if (!success) {
      _errorMessage = AppStrings.emailAlreadyExists;
    }

    _setLoading(false);
    return success;
  }

  Future<void> logout() async {
    await _logoutUseCase.execute();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    _setLoading(true);
    await _userManager.updateUser(updatedUser);
    _currentUser = updatedUser;
    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    if (_currentUser == null) return;
    _setLoading(true);
    await _userManager.deleteUser(_currentUser!.id);
    _currentUser = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
