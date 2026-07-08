
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSource(this._apiClient);

  Future<List<NotificationModel>> fetchNotifications(int page) async {
    final response = await _apiClient.get(
      '${ApiEndPoint.notifications}?page=$page',
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final List<dynamic> rawList = response.data['data'] ?? [];
    return rawList.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
