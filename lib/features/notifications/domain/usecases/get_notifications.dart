import '../../../../core/error/result.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationRepository _repository;

  Future<Result<List<NotificationEntity>>> call(int page) {
    return _repository.getNotifications(page);
  }
}
