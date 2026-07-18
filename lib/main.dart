import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/di.dart';
import 'core/error/error_handler.dart';
import 'core/services/socket/socket_service.dart';
import 'core/storage/storage_services.dart';

void main() => runZonedGuarded(_startPoint, _reportUncaughtError);

Future<void> _startPoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  FlutterError.onError = (e) => globalError(e.exception, e.stack);
  runApp(const MyApp());
}

void _reportUncaughtError(Object e, StackTrace s) => globalError(e, s);

Future<void> _initialize() async {
  try {
    await Future.wait([
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
      LocalStorage.init(),
    ]);
    dependencyInjection();
    Future.delayed(const Duration(milliseconds: 300), () {
      SocketService.connect();
    });
  } catch (error, stackTrace) {
    globalError(error, stackTrace);
  }
}
