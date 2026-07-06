import '../../../../../core/storeage/storage_services.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/sign_in_repository.dart';
import '../datasources/sign_in_remote_data_source.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInRemoteDataSource _remote;

  SignInRepositoryImpl(this._remote);

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final session = await _remote.signIn(email: email, password: password);

    await LocalStorage.saveToken(session.accessToken);
    await LocalStorage.saveRefreshToken(session.refreshToken);
    await LocalStorage.saveUser(session.user);

    return session;
  }
}
