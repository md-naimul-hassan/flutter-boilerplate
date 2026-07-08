
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/html_model.dart';

class SettingRemoteDataSource {
  final ApiClient _apiClient;

  SettingRemoteDataSource(this._apiClient);

  Future<void> deleteAccount(String password) async {
    final response = await _apiClient.delete(
      ApiEndPoint.user,
      body: {'password': password.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }
  }

  Future<HtmlModel> fetchPrivacyPolicy() async {
    final response = await _apiClient.get(ApiEndPoint.privacyPolicies);

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> rawData = response.data['data'] ?? {};
    final Map<String, dynamic> raw = rawData['attributes'] ?? {};
    return HtmlModel.fromJson(raw);
  }

  Future<HtmlModel> fetchTermsOfServices() async {
    final response = await _apiClient.get(ApiEndPoint.termsOfServices);

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> rawData = response.data['data'] ?? {};
    final Map<String, dynamic> raw = rawData['attributes'] ?? {};
    return HtmlModel.fromJson(raw);
  }
}
