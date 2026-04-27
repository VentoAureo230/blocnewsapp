import 'package:blocnewsapp/features/authentication/domain/entities/authentication.dart';

class AuthenticationModel extends AuthenticationEntity {
  const AuthenticationModel({
    super.email,
    super.username,
    super.createdAt,
    super.token,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationModel(
      email: json['email'] as String?,
      username: (json['username'] ?? json['name']) as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      token: json['token'] as String?,
    );
  }
}