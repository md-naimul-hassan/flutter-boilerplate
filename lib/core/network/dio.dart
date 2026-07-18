import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../app/constants/api_end_point.dart';
import '../utils/logger.dart';
import 'auth_interceptor.dart';

class DioConfig {
  DioConfig._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode) apiLog(),
    ]);

    return dio;
  }
}
