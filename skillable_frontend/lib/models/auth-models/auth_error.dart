class AuthError {
  final String error;

  AuthError({required this.error});

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(error: json['error'] as String);
  }
}