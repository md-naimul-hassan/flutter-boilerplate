import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_response_handler.dart';
import 'api_response_model.dart';
import 'multipart_helper.dart';
import 'config.dart';

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient({Dio? dio}) : _dio = dio ?? DioConfig.create();

  @override
  Future<ApiResponseModel> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'GET', query: query, headers: headers);
  }

  @override
  Future<ApiResponseModel> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'POST', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'PUT', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'PATCH', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) {
    return _request(url, method: 'DELETE', body: body, headers: headers);
  }

  @override
  Future<ApiResponseModel> multipart({
    required String url,
    List<MultipartFileItem> files = const [],
    Map<String, String> body = const {},
    String method = 'POST',
    Map<String, String>? headers,
  }) async {
    final formData = await MultipartHelper.build(files: files, fields: body);
    return _request(url, method: method, body: formData, headers: headers);
  }

  Future<ApiResponseModel> _request(
    String url, {
    required String method,
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );

      return ApiResponseHandler.handleSuccess(response);
    } catch (e) {
      return ApiResponseHandler.handleError(e);
    }
  }
}
