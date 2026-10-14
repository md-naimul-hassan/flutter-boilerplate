import '../../../../../core/error/result.dart';
import '../repositories/forgot_password_repository.dart';

class VerifyResetOtp {
  const VerifyResetOtp(this._repository);

  final ForgotPasswordRepository _repository;

  Future<Result<String>> call({required String email, required String otp}) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
