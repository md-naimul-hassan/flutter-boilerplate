// app_exceptions.dart

import '../../app/constants/app_string.dart';

class AppException implements Exception {
  final String? _message;
  final int? _statusCode;
  AppException([this._statusCode, this._message]);

  String get message => _message ?? AppString.somethingIsWrong;
  int get statusCode => _statusCode ?? 400;

  @override
  String toString() {
    return 'Exception: $_statusCode => $_message';
  }
}
class ApiException extends AppException {
  ApiException(super.statusCode, super.message);
}


/// No Internet Connection
class InternetException extends AppException {
  InternetException([super.statusCode = 404, super.message]);
}

/// Request Timeout (408)
class RequestTimeoutException extends AppException {
  RequestTimeoutException([super.statusCode = 408, super.message]);
}

/// Server Error (500)
class ServerException extends AppException {
  ServerException([super.statusCode = 500, super.message]);
}

/// Invalid URL
class InvalidUrlException extends AppException {
  InvalidUrlException([super.statusCode = 400, super.message]);
}

/// Unable to fetch data
class FetchDataException extends AppException {
  FetchDataException([super.statusCode = 400, super.message]);
}

/// Bad Request (400)
class BadRequestException extends AppException {
  BadRequestException([super.statusCode = 400, super.message]);
}

/// Unauthorized (401)
class UnauthorizedException extends AppException {
  UnauthorizedException([super.statusCode = 401, super.message]);
}

/// Forbidden (403)
class ForbiddenException extends AppException {
  ForbiddenException([super.statusCode = 403, super.message]);
}

/// Not Found (404)
class NotFoundException extends AppException {
  NotFoundException([super.statusCode = 404, super.message]);
}

/// Conflict (409)
class ConflictException extends AppException {
  ConflictException([super.statusCode = 409, super.message]);
}

/// Validation Failed (422)
class ValidationException extends AppException {
  ValidationException([super.statusCode = 422, super.message]);
}

/// Unknown Error
class UnknownException extends AppException {
  UnknownException([super.statusCode = 500, super.message]);
}
