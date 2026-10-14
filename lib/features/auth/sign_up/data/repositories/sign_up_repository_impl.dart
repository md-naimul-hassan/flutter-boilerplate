import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/storage/storage_services.dart';
import '../../domain/repositories/sign_up_repository.dart';
import '../datasources/sign_up_remote_data_source.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  const SignUpRepositoryImpl(this._remoteDataSource);

  final SignUpRemoteDataSource _remoteDataSource;

  @override
  Future<Result<String>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final token = await _remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return Success(token);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<String>> resendOtp({required String email}) async {
    try {
      return Success(await _remoteDataSource.resendOtp(email: email));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<void>> verifyEmail({
    required String otp,
    required String signUpToken,
  }) async {
    try {
      final session = await _remoteDataSource.verifyEmail(
        otp: otp,
        signUpToken: signUpToken,
      );
      await Future.wait([
        LocalStorage.saveToken(session.accessToken),
        LocalStorage.saveRefreshToken(session.refreshToken),
        LocalStorage.saveUser(session.user.toMap()),
      ]);
      return const Success(null);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
