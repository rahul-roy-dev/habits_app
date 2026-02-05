import 'package:hive_ce/hive.dart';
import 'package:habits_app/core/constants/app_values.dart';

part 'user_model.g.dart';

@HiveType(typeId: AppValues.hiveUserTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String password;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });
}
