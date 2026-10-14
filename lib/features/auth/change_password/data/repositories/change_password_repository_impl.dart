import '../../../../../core/error/failures.dart';
import '../../../../../core/error/result.dart';
import '../../domain/repositories/change_password_repository.dart';
import '../datasources/change_password_remote_data_source.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  const ChangePasswordRepositoryImpl(this._remoteDataSource);

  final ChangePasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Result<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final message = await _remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return Success(message);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
