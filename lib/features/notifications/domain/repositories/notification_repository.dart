import '../../../../core/error/result.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationEntity>>> getNotifications(int page);
}
