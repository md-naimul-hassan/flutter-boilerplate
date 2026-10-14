import '../../../../../core/models/user_model.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserModel user;

  factory AuthSessionModel.fromJson(Map<String, dynamic>? json) {
    return AuthSessionModel(
      accessToken: json?['accessToken'] ?? '',
      refreshToken: json?['refreshToken'] ?? '',
      user: UserModel.fromJson(json?['user']),
    );
  }
}
