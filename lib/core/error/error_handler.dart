import 'dart:developer';

void globalLog(Object? message) {
  log(message.toString(), name: 'APP_LOG');
}

void globalError(Object error, StackTrace? stack) {
  log(
    error.toString(),
    name: 'APP_LOG',
    error: error,
    stackTrace: stack,
  );
}
