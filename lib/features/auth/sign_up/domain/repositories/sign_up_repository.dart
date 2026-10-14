import '../../../../../core/error/result.dart';

abstract class SignUpRepository {
  Future<Result<String>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<String>> resendOtp({required String email});

  Future<Result<void>> verifyEmail({
    required String otp,
    required String signUpToken,
  });
}
