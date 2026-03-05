class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;
}
