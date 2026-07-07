import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';

class ChangePasswordRemoteDataSource {
  final ApiClient _apiClient;

  ChangePasswordRemoteDataSource(this._apiClient);

  /// Changes the user's password and returns the success message.
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


