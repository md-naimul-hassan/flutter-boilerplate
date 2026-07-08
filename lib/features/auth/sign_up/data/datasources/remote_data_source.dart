import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/storage/storage_services.dart';

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
        'password': password.trim(),
      },
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    return data['signUpToken'] ?? '';
  }

  Future<String> resendOtp({required String email}) async {
    final response = await _apiClient.post(
      ApiEndPoint.resendOtp,
      body: {'email': email.trim()},
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
      body: {'otp': otp},
      headers: {'SignUpToken': 'signUpToken $signUpToken'},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};

    await Future.wait([
      LocalStorage.saveToken(data['accessToken']),
      LocalStorage.saveRefreshToken(data['refreshToken']),
      LocalStorage.saveUser(data['user']),
    ]);
  }
}
