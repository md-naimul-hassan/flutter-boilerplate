import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<String> sendResetEmail({required String email});

  Future<String> verifyOtp({required String email, required String otp});

  Future<String> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
    required String token,
  });
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  const ForgotPasswordRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
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

  @override
  Future<String> verifyOtp({required String email, required String otp}) async {
    final response = await _apiClient.post(
      ApiEndPoint.verifyEmail,
      body: {'email': email.trim(), 'otp': otp.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final  data = response.data['data'] ;
    return data ?? '';
  }

  @override
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
