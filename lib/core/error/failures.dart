import 'package:equatable/equatable.dart';

import '../../app/constants/app_string.dart';
import '../utils/logger.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = AppString.somethingIsWrong,
    super.statusCode,
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = AppString.noInternetConnection,
    super.statusCode,
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = AppString.somethingIsWrong,
    super.statusCode = 401,
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = AppString.unknownError]);
}

Failure catchFailure(Object error) {
  return switch (error) {
    InternetException(:final message) => NetworkFailure(message),
    AppException(statusCode: 401, :final message) => UnauthorizedFailure(
      message,
    ),
    AppException(:final statusCode, :final message)
        when statusCode == 408 || statusCode == 503 =>
      NetworkFailure(message, statusCode),
    AppException(:final message, :final statusCode) => ServerFailure(
      message,
      statusCode,
    ),
    _ => _unknown(error),
  };
}

Failure _unknown(Object error) {
  logError(error);
  return const UnknownFailure();
}
