import 'package:hive_flutter/hive_flutter.dart';
import 'package:habits_app/data/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:habits_app/abstracts/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  static const String _userBoxName = 'userBox';
  static const String _sessionBoxName = 'sessionBox';
  static const String _currentUserKey = 'currentUser';

  @override
  Future<void> init() async {
    await Hive.openBox<UserModel>(_userBoxName);
    await Hive.openBox(_sessionBoxName);
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    final box = Hive.box<UserModel>(_userBoxName);
    if (box.values.any((u) => u.email == email)) {
      return false;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: _hashPassword(password),
    );

    await box.add(newUser);
    return true;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final box = Hive.box<UserModel>(_userBoxName);
    final hashedPassword = _hashPassword(password);

    try {
      final user = box.values.firstWhere(
        (u) => u.email == email && u.password == hashedPassword,
      );

      await _setCurrentUser(user);
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<void> _setCurrentUser(UserModel user) async {
    final sessionBox = Hive.box(_sessionBoxName);
    await sessionBox.put(_currentUserKey, user.id);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final sessionBox = Hive.box(_sessionBoxName);
    final userId = sessionBox.get(_currentUserKey);

    if (userId == null) return null;

    final box = Hive.box<UserModel>(_userBoxName);
    try {
      return box.values.firstWhere((u) => u.id == userId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final sessionBox = Hive.box(_sessionBoxName);
    await sessionBox.delete(_currentUserKey);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final box = Hive.box<UserModel>(_userBoxName);
    final userToUpdate = box.values.firstWhere((u) => u.id == user.id);
    await box.put(userToUpdate.key, user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final box = Hive.box<UserModel>(_userBoxName);
    final userToDelete = box.values.firstWhere((u) => u.id == userId);
    await userToDelete.delete();
    
    final currentUser = await getCurrentUser();
    if (currentUser?.id == userId) {
      await logout();
    }
  }
}
