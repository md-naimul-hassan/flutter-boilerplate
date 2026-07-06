import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/services/api/api_client.dart';
import '../models/auth_session_model.dart';

abstract class SignInRemoteDataSource {
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  });
}

class SignInRemoteDataSourceImpl implements SignInRemoteDataSource {
  final ApiClient _apiClient;

  SignInRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndPoint.signIn,
      body: {'email': email, 'password': password},
    );

    if (!response.isSuccess) {
      throw SignInException(response.message, response.statusCode);
    }

    final data = (response.data['data'] as Map?)?.cast<String, dynamic>() ?? {};
    return AuthSessionModel.fromJson(data);
  }
}

class SignInException implements Exception {
  final String message;
  final int statusCode;
  SignInException(this.message, this.statusCode);

  @override
  String toString() => message;
}
