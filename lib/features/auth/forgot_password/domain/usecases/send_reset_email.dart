import '../../../../../core/error/result.dart';
import '../repositories/forgot_password_repository.dart';

class SendResetEmail {
  const SendResetEmail(this._repository);

  final ForgotPasswordRepository _repository;

  Future<Result<String>> call({required String email}) {
    return _repository.sendResetEmail(email: email);
  }
}
