import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_data_source.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  const ForgotPasswordRepositoryImpl(this._remoteDataSource);

  final ForgotPasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Result<String>> sendResetEmail({required String email}) async {
    try {
      return Success(await _remoteDataSource.sendResetEmail(email: email));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return Success(await _remoteDataSource.verifyOtp(email: email, otp: otp));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<String>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final message = await _remoteDataSource.resetPassword(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        token: token,
      );
      return Success(message);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
