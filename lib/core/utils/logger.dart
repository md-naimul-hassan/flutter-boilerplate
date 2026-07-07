import 'package:logger/web.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';


PrettyDioLogger apiLog() {
  return PrettyDioLogger(requestHeader: true, requestBody: true);
}

final logger = Logger();

void logDebug(dynamic message) {
  logger.d(message);
}

void logInfo(dynamic message) {
  logger.i(message);
}

void logWarning(dynamic message) {
  logger.w(message);
}

void logError(dynamic message) {
  logger.e(message);
}

void logFatal(dynamic message) {
  logger.f(message);
}



void globalError(Object error, StackTrace? stack) {
  debugPrint(' Global Error ❌ ERROR: $error');
  if (stack != null) {
    debugPrint('Global Error 📌 STACK TRACE:\n$stack');
  }
  // Optional: Send to remote logging
  // FirebaseCrashlytics.instance.recordError(error, stack);
}

void setupGlobalLogging() {
  final originalDebugPrint = debugPrint;
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message == null) return;
    originalDebugPrint('➡️debugPrint: $message', wrapWidth: wrapWidth);
  };
}