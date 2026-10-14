import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/storage/storage_services.dart';
import '../../domain/repositories/sign_in_repository.dart';
import '../datasources/sign_in_remote_data_source.dart';

class SignInRepositoryImpl implements SignInRepository {
  const SignInRepositoryImpl(this._remoteDataSource);

  final SignInRemoteDataSource _remoteDataSource;

  @override
  Future<Result<void>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.signIn(
        email: email,
        password: password,
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
