import 'package:dio/dio.dart';

import '../storage/storage_services.dart';


class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'Authorization': 'Bearer ${LocalStorage.token}',
      'Content-Type': 'application/json',
    });

    super.onRequest(options, handler);
  }
}
