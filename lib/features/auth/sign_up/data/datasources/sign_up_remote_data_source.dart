import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../shared/data/models/auth_session_model.dart';

abstract class SignUpRemoteDataSource {
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<String> resendOtp({required String email});

  Future<AuthSessionModel> verifyEmail({
    required String otp,
    required String signUpToken,
  });
}

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  const SignUpRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
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

  @override
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

  @override
  Future<AuthSessionModel> verifyEmail({
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

    return AuthSessionModel.fromJson(response.data['data']);
  }
}
