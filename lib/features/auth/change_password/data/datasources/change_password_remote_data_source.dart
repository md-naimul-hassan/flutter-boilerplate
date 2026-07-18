import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';

abstract class ChangePasswordRemoteDataSource {
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class ChangePasswordRemoteDataSourceImpl
    implements ChangePasswordRemoteDataSource {
  const ChangePasswordRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await _apiClient.patch(
      ApiEndPoint.changePassword,
      body: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    return response.message;
  }
}
