import '../../../../../core/error/result.dart';

abstract class SignInRepository {
  Future<Result<void>> signIn({
    required String email,
    required String password,
  });
}
