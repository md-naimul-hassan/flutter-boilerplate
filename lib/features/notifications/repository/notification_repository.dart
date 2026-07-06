
import '../../../app/constants/api_end_point.dart';
import '../../../core/services/api/api_client.dart';
import '../../../core/services/api/api_service.dart';
import '../data/model/notification_model.dart';

Future<List<NotificationModel>> notificationRepository(int page) async {
  try {
    final ApiClient apiClient = DioApiClient();
    final response = await apiClient.get(
      '${ApiEndPoint.notifications}?page=$page',
    );

    if (response.statusCode != 200) {
      throw Exception(response.message);
    }

    final List<dynamic> rawList = response.data['data'] ?? [];

    return rawList.map((e) => NotificationModel.fromJson(e)).toList();
  } catch (e) {
    rethrow;
  }
}
