class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? bio;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.bio,
    this.avatar,
    this.role,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatar': avatar,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      bio: map['bio'],
      avatar: map['avatar'],
      role: map['role'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
