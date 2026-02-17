import 'package:flutter/material.dart';
import '../../../../config/route/app_routes.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_images.dart';
import '../../component/image/common_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Example logic
    // if (LocalStorage.token.isNotEmpty) {
    //   Get.offAllNamed(AppRoutes.home);
    // } else {
    //   Get.offAllNamed(AppRoutes.onboarding);
    // }

    Get.offAllNamed(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CommonImage(imageSrc: AppImages.noImage, size: 70),
        ),
      ),
    );
  }
}
