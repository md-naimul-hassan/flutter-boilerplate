import 'package:flutter/material.dart';
import '../error/error_handler.dart';
import 'app_lifecycle_handler.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final AppLifecycleHandler _lifecycleHandler = AppLifecycleHandler();

  @override
  void initState() {
    super.initState();
    _setupGlobalErrorHandling();
    _lifecycleHandler.start();
  }

  void _setupGlobalErrorHandling() {
    // Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      globalError(details.exception, details.stack);
    };

    // Widget build errors
    ErrorWidget.builder = (FlutterErrorDetails details) {
      globalError(details.exception, details.stack);

      return const Material(
        color: Colors.white,
        child: Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    };
  }

  @override
  void dispose() {
    _lifecycleHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
