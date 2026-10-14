import '../../../../../core/error/result.dart';
import '../repositories/sign_up_repository.dart';

class SignUp {
  const SignUp(this._repository);

  final SignUpRepository _repository;

  Future<Result<String>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
