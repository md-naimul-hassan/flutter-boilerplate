import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/html_entity.dart';
import '../../domain/repositories/setting_repository.dart';
import '../datasources/setting_remote_data_source.dart';

class SettingRepositoryImpl implements SettingRepository {
  const SettingRepositoryImpl(this._remoteDataSource);

  final SettingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<void>> deleteAccount(String password) async {
    try {
      await _remoteDataSource.deleteAccount(password);
      return const Success(null);
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<HtmlEntity>> getPrivacyPolicy() async {
    try {
      return Success(await _remoteDataSource.fetchPrivacyPolicy());
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<HtmlEntity>> getTermsOfServices() async {
    try {
      return Success(await _remoteDataSource.fetchTermsOfServices());
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
