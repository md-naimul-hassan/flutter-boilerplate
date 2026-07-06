import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';


PrettyDioLogger apiLog() {
  return PrettyDioLogger(requestHeader: true, requestBody: true);
}


void appLog(dynamic message, {String source = ''}) {
  try {
    if (kDebugMode) {
      debugPrint("""
${source.isNotEmpty ? ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" : ""}
      $source
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

               =============>${message.toString()}

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

""");
    }
  } catch (e) {
    errorLog(e, source: 'App Log');
  }
}



void errorLog(dynamic e, {String source = ''}) {
  try {
    if (kDebugMode) {
      log('''
      >>>>>>>>>>>>>>>>>>>>>>>>>>>😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
          
          $source

      >>>>>>>>>>>>>>>>>>>>>>>>>>>😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


     ➡️➡️➡️➡️➡️ :========>  ${e.toString()} 🔚🔚🔚🔚🔚🔚🔚🔚
      

      <<<<<<<<<<<<<<<<<<<<<<<<<<<😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      ''');
    }
  } catch (e) {
    debugPrint(e.toString());
  }
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