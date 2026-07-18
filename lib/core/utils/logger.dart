import 'package:logger/web.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

PrettyDioLogger apiLog() {
  return PrettyDioLogger(requestHeader: true, requestBody: true);
}

final logger = Logger();

void logDebug(dynamic message) {
  if (!kDebugMode) return;
  logger.d(message);
}

void logInfo(dynamic message) {
  if (!kDebugMode) return;
  logger.i(message);
}

void logWarning(dynamic message) {
  if (!kDebugMode) return;
  logger.w(message);
}

void logError(dynamic message) {
  if (!kDebugMode) return;
  logger.e(message);
}

void logFatal(dynamic message) {
  if (!kDebugMode) return;
  logger.f(message);
}
