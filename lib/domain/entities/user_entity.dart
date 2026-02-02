class UserEntity {
  final String id;
  final String email;
  final String name;
  final String password;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          password == other.password;

  @override
  int get hashCode => Object.hash(id, email, name, password);
}
