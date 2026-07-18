import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/core/utils/logger.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  void start() {
    WidgetsBinding.instance.addObserver(this);
    logInfo('Lifecycle observer started');
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    logInfo('Lifecycle observer stopped');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logInfo('App lifecycle: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        logInfo('App resumed');
        break;

      case AppLifecycleState.inactive:
        logInfo('App inactive');
        break;

      case AppLifecycleState.paused:
        logInfo('App paused');
        break;

      case AppLifecycleState.detached:
        logInfo('App detached');
        break;

      case AppLifecycleState.hidden:
        logInfo('App hidden');
        break;
    }
  }
}
