import '../../../../app/constants/api_end_point.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/multipart_helper.dart';
import '../../../../core/storeage/storage_services.dart';

class ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource(this._apiClient);

  Future<void> updateProfile({
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
      throw Exception(response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    await LocalStorage.saveUser(data['user']);
  }
}
