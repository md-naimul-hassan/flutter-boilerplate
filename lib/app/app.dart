import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app/router.dart';
import '../app/theme.dart';
import '../core/component/scroll_behavior/scroll_behavior.dart';
import '../core/utils/app_snackbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Size _designSize = Size(428, 926);

  @override
  Widget build(BuildContext context) {
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
}
