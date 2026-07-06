import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/router.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/pop_up/common_pop_menu.dart';
import '../../../../core/component/text/common_text.dart';
import '../controller/setting_controller.dart';
import '../widgets/setting_item.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        title: const CommonText(
          text: AppString.settings,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      /// Body
      body: GetBuilder<SettingController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: .symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              children: [
                /// Change password
                SettingItem(
                  title: AppString.changePassword,
                  iconData: Icons.lock_outline,
                  onTap: () => Get.toNamed(AppRoutes.changePassword),
                ),

                /// Terms
                SettingItem(
                  title: AppString.termsOfServices,
                  iconData: Icons.gavel,
                  onTap: () => Get.toNamed(AppRoutes.termsOfServices),
                ),

                /// Privacy
                SettingItem(
                  title: AppString.privacyPolicy,
                  iconData: Icons.privacy_tip_outlined,
                  onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                ),

                /// Delete account
                SettingItem(
                  title: AppString.deleteAccount,
                  iconData: Icons.delete_outline_rounded,
                  textColor: Colors.red,
                  onTap: () => deletePopUp(
                    controller: controller.passwordController,
                    onTap: controller.deleteAccount,
                    isLoading: controller.isLoading,
                  ),
                ),
              ],
            ),
          );
        },
      ),

      /// Bottom nav
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 0),
    );
  }
}
