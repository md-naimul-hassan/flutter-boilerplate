
import '../../app/constants/app_string.dart';

class ApiResponseModel {
  final int? _statusCode;
  final Map<String, dynamic>? _data;

  ApiResponseModel(this._statusCode, this._data);

  bool get isSuccess => _statusCode == 200 || _statusCode == 201;
  int get statusCode => _statusCode ?? 400;

  String get message {
    if (_statusCode == 502) {
      return AppString.startServer;
    }
    return _data?['message'] ?? AppString.somethingIsWrong;
  }

  Map<String, dynamic> get data => _data ?? {};
}
