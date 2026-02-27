class AuthUser {
  final int id;
  final String username;
  final String email;
  final String? createdAt;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.createdAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'created_at': createdAt,
      };
}
