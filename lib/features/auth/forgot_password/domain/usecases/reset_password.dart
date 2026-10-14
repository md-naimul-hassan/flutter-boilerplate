import '../../../../../core/error/result.dart';
import '../repositories/forgot_password_repository.dart';

class ResetPassword {
  const ResetPassword(this._repository);

  final ForgotPasswordRepository _repository;

  Future<Result<String>> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  }) {
    return _repository.resetPassword(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      token: token,
    );
  }
}
