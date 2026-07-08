import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';

class ForgotPasswordRemoteDataSource {
  final ApiClient _apiClient;

  ForgotPasswordRemoteDataSource(this._apiClient);

  Future<String> sendResetEmail({required String email}) async {
    final response = await _apiClient.post(
      ApiEndPoint.forgotPassword,
      body: {'email': email.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    return response.message;
  }

  Future<String> verifyOtp({required String email, required String otp}) async {
    final response = await _apiClient.post(
      ApiEndPoint.verifyOtp,
      body: {'email': email.trim(), 'otp': otp.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    return data['forgetPasswordToken'] ?? '';
  }

  Future<String> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    final response = await _apiClient.post(
      ApiEndPoint.resetPassword,
      headers: {'Forget-password': 'Forget-password $token'},
      body: {
        'email': email.trim(),
        'password': password.trim(),
        'confirmPassword': confirmPassword.trim(),
      },
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    return response.message;
  }
}
