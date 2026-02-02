import 'package:hive_flutter/hive_flutter.dart';
import 'package:habits_app/data/models/user_model.dart';
import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/i_auth_repository.dart';
import 'package:habits_app/core/constants/app_values.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthRepository implements IAuthRepository {
  @override
  Future<void> init() async {
    await Hive.openBox<UserModel>(AppValues.userBoxName);
    await Hive.openBox(AppValues.sessionBoxName);
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Convert UserModel to UserEntity
  UserEntity _toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      name: model.name,
      password: model.password,
    );
  }

  // Convert UserEntity to UserModel
  UserModel _toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      password: entity.password,
    );
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    final box = Hive.box<UserModel>(AppValues.userBoxName);
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
  Future<UserEntity?> login(String email, String password) async {
    final box = Hive.box<UserModel>(AppValues.userBoxName);
    final hashedPassword = _hashPassword(password);

    try {
      final user = box.values.firstWhere(
        (u) => u.email == email && u.password == hashedPassword,
      );

      await _setCurrentUser(user);
      return _toEntity(user);
    } catch (_) {
      return null;
    }
  }

  Future<void> _setCurrentUser(UserModel user) async {
    final sessionBox = Hive.box(AppValues.sessionBoxName);
    await sessionBox.put(AppValues.currentUserKey, user.id);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final sessionBox = Hive.box(AppValues.sessionBoxName);
    final userId = sessionBox.get(AppValues.currentUserKey);

    if (userId == null) return null;

    final box = Hive.box<UserModel>(AppValues.userBoxName);
    try {
      return _toEntity(box.values.firstWhere((u) => u.id == userId));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final sessionBox = Hive.box(AppValues.sessionBoxName);
    await sessionBox.delete(AppValues.currentUserKey);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final box = Hive.box<UserModel>(AppValues.userBoxName);
    final userToUpdate = box.values.firstWhere((u) => u.id == user.id);
    await box.put(userToUpdate.key, _toModel(user));
  }

  @override
  Future<void> deleteUser(String userId) async {
    final box = Hive.box<UserModel>(AppValues.userBoxName);
    final userToDelete = box.values.firstWhere((u) => u.id == userId);
    await userToDelete.delete();
    
    final currentUser = await getCurrentUser();
    if (currentUser?.id == userId) {
      await logout();
    }
  }
}
