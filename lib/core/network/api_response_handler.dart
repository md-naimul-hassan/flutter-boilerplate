import 'package:dio/dio.dart';

import '../../app/constants/app_string.dart';
import 'api_response_model.dart';

class ApiResponseHandler {
  static ApiResponseModel handleSuccess(Response<dynamic> response) {
    return ApiResponseModel(response.statusCode, response.data);
  }

  static ApiResponseModel handleError(dynamic error) {
    if (error is DioException) return _mapDioError(error);
    return ApiResponseModel(500, {'message': AppString.somethingIsWrong});
  }

  static ApiResponseModel _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiResponseModel(408, {'message': AppString.requestTimeOut});

      case DioExceptionType.connectionError:
        return ApiResponseModel(503, {
          'message': AppString.noInternetConnection,
        });

      case DioExceptionType.badResponse:
        return ApiResponseModel(
          error.response?.statusCode,
          error.response?.data,
        );

      default:
        return ApiResponseModel(400, {});
    }
  }
}
