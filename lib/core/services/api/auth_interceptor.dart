import 'package:dio/dio.dart';

import '../../storeage/storage_services.dart';


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
