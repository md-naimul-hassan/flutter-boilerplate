import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/storeage/storage_services.dart';

class SignUpRemoteDataSource {
  final ApiClient _apiClient;

  SignUpRemoteDataSource(this._apiClient);

  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndPoint.signUp,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'phone': '+880',
        'password': password.trim(),
        'pin': '1234',
      },
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    return data['signUpToken'] ?? '';
  }

  Future<void> verifyEmail({
    required String otp,
    required String signUpToken,
  }) async {
    final response = await _apiClient.post(
      ApiEndPoint.verifyEmail,
      body: {'otp': otp, 'userId': '6a4ccc2b0475a6ae82140295'},
      headers: {'SignUpToken': 'signUpToken $signUpToken'},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    await LocalStorage.saveToken(data['accessToken']);
    await LocalStorage.saveRefreshToken(data['refreshToken']);
    await LocalStorage.saveUser(data['user']);
  }
}
