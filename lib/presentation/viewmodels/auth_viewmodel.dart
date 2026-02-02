import 'package:flutter/material.dart';
import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/i_auth_repository.dart';
import 'package:habits_app/core/constants/app_strings.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  AuthViewModel({required IAuthRepository repository})
    : _authRepository = repository;

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

    _currentUser = await _authRepository.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    _currentUser = await _authRepository.login(email, password);

    if (_currentUser == null) {
      _errorMessage = AppStrings.invalidEmailOrPassword;
    }

    _setLoading(false);
    return _currentUser != null;
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final success = await _authRepository.register(name, email, password);

    if (!success) {
      _errorMessage = AppStrings.emailAlreadyExists;
    }

    _setLoading(false);
    return success;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    _setLoading(true);
    await _authRepository.updateUser(updatedUser);
    _currentUser = updatedUser;
    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    if (_currentUser == null) return;
    _setLoading(true);
    await _authRepository.deleteUser(_currentUser!.id);
    _currentUser = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
