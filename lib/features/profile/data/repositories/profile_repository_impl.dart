import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/storage_services.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<void>> updateProfile({
    required String fullName,
    required String phone,
    String? imagePath,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
        imagePath: imagePath,
      );
      await LocalStorage.saveUser(user.toMap());
      return const Success(null);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
