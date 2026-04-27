class AuthenticationEntity {
  final String? email;
  final String? username;
  final DateTime? createdAt;
  final String? token;

  const AuthenticationEntity({
    this.email,
    this.username,
    this.createdAt,
    this.token,
  });
}