import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../shared/data/models/auth_session_model.dart';

abstract class SignInRemoteDataSource {
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  });
}

class SignInRemoteDataSourceImpl implements SignInRemoteDataSource {
  const SignInRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndPoint.signIn,
      body: {'email': email.trim(), 'password': password.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    return AuthSessionModel.fromJson(response.data['data']);
  }
}
