import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/app/router.dart';
import 'package:untitled/app/theme.dart';

import '../core/component/scroll_behavior/scroll_behavior.dart';
import '../core/error/error_handler.dart';
import '../core/storeage/storage_services.dart';
import 'di.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Size _designSize = Size(428, 926);
  static const Duration _routeTransitionDuration = Duration(milliseconds: 300);
  static const Duration _socketStartupDelay = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    /// Defer heavy init until after the first frame so the UI appears instantly.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
    return ScreenUtilInit(
      designSize: _designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        theme: themeData,
        scrollBehavior: const AppScrollBehavior(),
        defaultTransition: Transition.fadeIn,
        transitionDuration: _routeTransitionDuration,
        getPages: AppRoutes.routes,
        initialRoute: AppRoutes.changePassword,
        home: child,
      ),
    );
  }

  /// Initialize app after the first frame.
  /// This is done to ensure that the UI appears instantly.
  /// This method is called by the `_startPoint` method.
  Future<void> _initializeApp() async {
    try {
      DependencyInjection().dependencies();
      await Future.wait([
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        LocalStorage.init(),
      ]);
     // Future.delayed(_socketStartupDelay, SocketService.connect);
    } catch (error, stackTrace) {
      globalError(error, stackTrace);
    }
  }
}
