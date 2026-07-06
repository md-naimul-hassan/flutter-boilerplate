import 'package:flutter/widgets.dart';

import '../error/error_handler.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  void start() {
    WidgetsBinding.instance.addObserver(this);
    globalLog('Lifecycle observer started');
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    globalLog('Lifecycle observer stopped');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    globalLog('App lifecycle: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        globalLog('App resumed');
        break;

      case AppLifecycleState.inactive:
        globalLog('App inactive');
        break;

      case AppLifecycleState.paused:
        globalLog('App paused');
        break;

      case AppLifecycleState.detached:
        globalLog('App detached');
        break;

      case AppLifecycleState.hidden:
        globalLog('App hidden');
        break;
    }
  }
}
