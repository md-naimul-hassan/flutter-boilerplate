import '../../../../../core/error/result.dart';
import '../repositories/sign_up_repository.dart';

class VerifyEmail {
  const VerifyEmail(this._repository);

  final SignUpRepository _repository;

  Future<Result<void>> call({
    required String otp,
    required String signUpToken,
  }) {
    return _repository.verifyEmail(otp: otp, signUpToken: signUpToken);
  }
}
