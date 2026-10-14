import '../../../../../core/error/result.dart';
import '../repositories/sign_up_repository.dart';

class ResendSignUpOtp {
  const ResendSignUpOtp(this._repository);

  final SignUpRepository _repository;

  Future<Result<String>> call({required String email}) {
    return _repository.resendOtp(email: email);
  }
}
