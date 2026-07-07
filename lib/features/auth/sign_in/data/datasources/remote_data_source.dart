import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/storeage/storage_services.dart';

class SignInRemoteDataSource {
  final ApiClient _apiClient;

  SignInRemoteDataSource(this._apiClient);

  Future<void> signIn({required String email, required String password}) async {
    final response = await _apiClient.post(
      ApiEndPoint.signIn,
      body: {'email': email.trim(), 'password': password.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};

    Future.wait([
      LocalStorage.saveToken(data['accessToken']),
      LocalStorage.saveRefreshToken(data['refreshToken']),
      LocalStorage.saveUser(data['user']),
    ]);
  }
}
