class UserEntity {
  final String id;
  final String name;
  final String? email;
  final String? bio;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    this.email,
    this.bio,
    this.avatar,
    this.role,
    this.createdAt,
  });
}
