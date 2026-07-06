import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/router.dart';
import '../../core/component/image/common_image.dart';
import '../../app/constants/app_images.dart';


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
    Get.toNamed(AppRoutes.onboarding);

    // Example logic
    // final route = LocalStorage.token.isNotEmpty
    //     ? AppRoutes.home
    //     : AppRoutes.onboarding;
    // Get.offAllNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CommonImage(imageSrc: AppImages.noImage, size: 70)),
    );
  }
}
