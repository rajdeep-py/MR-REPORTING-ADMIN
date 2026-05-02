class AdminUser {
  final String id;
  final String email;
  final String name;

  AdminUser({
    required this.id,
    required this.email,
    required this.name,
  });

  AdminUser copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
