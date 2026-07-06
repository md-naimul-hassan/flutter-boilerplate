import 'dart:async';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/error/error_handler.dart';

void main() => runZonedGuarded(_startPoint, _reportUncaughtError);

Future<void> _startPoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (e) => globalError(e.exception, e.stack);
  runApp(const MyApp());
}

void _reportUncaughtError(Object e, StackTrace s) => globalError(e, s);
