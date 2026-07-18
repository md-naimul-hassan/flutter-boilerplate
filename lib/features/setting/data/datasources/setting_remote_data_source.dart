import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/html_model.dart';

abstract class SettingRemoteDataSource {
  Future<void> deleteAccount(String password);

  Future<HtmlModel> fetchPrivacyPolicy();

  Future<HtmlModel> fetchTermsOfServices();
}

class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  const SettingRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> deleteAccount(String password) async {
    final response = await _apiClient.delete(
      ApiEndPoint.user,
      body: {'password': password.trim()},
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }
  }

  @override
  Future<HtmlModel> fetchPrivacyPolicy() =>
      _fetchHtml(ApiEndPoint.privacyPolicies);

  @override
  Future<HtmlModel> fetchTermsOfServices() =>
      _fetchHtml(ApiEndPoint.termsOfServices);

  Future<HtmlModel> _fetchHtml(String url) async {
    final response = await _apiClient.get(url);

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> rawData = response.data['data'] ?? {};
    final Map<String, dynamic> raw = rawData['attributes'] ?? {};
    return HtmlModel.fromJson(raw);
  }
}
