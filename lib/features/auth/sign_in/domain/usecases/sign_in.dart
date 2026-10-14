import '../../../../../core/error/result.dart';
import '../repositories/sign_in_repository.dart';

class SignIn {
  const SignIn(this._repository);

  final SignInRepository _repository;

  Future<Result<void>> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
