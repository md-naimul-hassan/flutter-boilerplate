import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../core/component/image/common_image.dart';
import '../../app/constants/app_images.dart';
import '../../core/storage/storage_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final route = LocalStorage.isLogin
        ? AppRoutes.profile
        : AppRoutes.onboarding;
    AppNavigator.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CommonImage(imageSrc: AppImages.noImage, size: 70)),
    );
  }
}
