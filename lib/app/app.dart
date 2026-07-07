import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/app/router.dart';
import 'package:untitled/app/theme.dart';

import '../core/component/scroll_behavior/scroll_behavior.dart';
import '../core/error/error_handler.dart';
import '../core/storeage/storage_services.dart';
import '../core/utils/app_snackbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Size _designSize = Size(428, 926);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeApp());
    return ScreenUtilInit(
      designSize: _designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: themeData,
        scrollBehavior: const AppScrollBehavior(),
        routerConfig: appRouter,
      ),
    );
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        LocalStorage.init(),
      ]);
    } catch (error, stackTrace) {
      globalError(error, stackTrace);
    }
  }
}
