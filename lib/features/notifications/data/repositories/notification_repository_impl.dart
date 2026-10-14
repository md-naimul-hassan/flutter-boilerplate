import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<NotificationEntity>>> getNotifications(int page) async {
    try {
      return Success(await _remoteDataSource.fetchNotifications(page));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }
}
