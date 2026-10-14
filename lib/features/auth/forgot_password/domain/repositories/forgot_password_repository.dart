import '../../../../../core/error/result.dart';

abstract class ForgotPasswordRepository {
  Future<Result<String>> sendResetEmail({required String email});

  Future<Result<String>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Result<String>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  });
}
