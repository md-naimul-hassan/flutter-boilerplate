import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

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

    final cookieJar = CookieJar();

    dio.interceptors.addAll([
      AuthInterceptor(),
      CookieManager(cookieJar),
      apiLog(),
    ]);

    return dio;
  }
}
