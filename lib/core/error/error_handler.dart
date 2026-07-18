import 'dart:developer';

void globalError(Object error, StackTrace? stack) {
  log(
    error.toString(),
    name: 'APP_LOG',
    error: error,
    stackTrace: stack,
  );
}
