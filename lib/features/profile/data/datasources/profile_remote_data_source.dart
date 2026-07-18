import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/multipart_helper.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    required String fullName,
    required String phone,
    String? imagePath,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<UserModel> updateProfile({
    required String fullName,
    required String phone,
    String? imagePath,
  }) async {
    final files = imagePath != null
        ? [MultipartFileItem(fileName: 'image', filePath: imagePath)]
        : <MultipartFileItem>[];

    final response = await _apiClient.multipart(
      url: ApiEndPoint.user,
      body: {'fullName': fullName.trim(), 'phone': phone.trim()},
      files: files,
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    return UserModel.fromJson(data['user']);
  }
}
