import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/constants/app_string.dart';
import '../../app/router.dart';
import '../../core/component/image/common_image.dart';
import '../../app/constants/app_images.dart';
import '../../core/utils/extension.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              180.height,

              /// Logo
              const CommonImage(imageSrc: AppImages.noImage, size: 90),
              120.height,

              /// Sign In
              ElevatedButton(
                onPressed: () => AppNavigator.push(AppRoutes.signIn),
                child: const Text(AppString.signIn),
              ),
              24.height,

              /// Sign Up
              ElevatedButton(
                onPressed: () => AppNavigator.push(AppRoutes.signUp),
                child: const Text(AppString.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
