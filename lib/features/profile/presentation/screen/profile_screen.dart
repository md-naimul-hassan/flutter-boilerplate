import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/router.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/other_widgets/item.dart';
import '../../../../core/component/pop_up/common_pop_menu.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/storeage/storage_services.dart';
import '../../../../core/utils/extension.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar
      appBar: AppBar(
        title: const CommonText(
          text: AppString.profile,
          fontWeight: .w600,
          fontSize: 24,
        ),
      ),

      /// Body
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          final user = LocalStorage.user;

          return SingleChildScrollView(
            padding: .symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              children: [
                /// Profile image
                16.height,

                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CommonImage(imageSrc: user.image, size: 140),
                  ),
                ),

                /// Name
                CommonText(text: user.name, fontSize: 18, fontWeight: .w700),

                24.height,

                /// Edit profile
                Item(
                  icon: Icons.person,
                  title: AppString.editProfile,
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                ),

                /// Settings
                Item(
                  icon: Icons.settings,
                  title: AppString.settings,
                  onTap: () => Get.toNamed(AppRoutes.setting),
                ),

                /// Language
                Padding(
                  padding: .symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.language),

                          12.width,

                          CommonText(
                            text: controller.selectedLanguage,
                            fontSize: 16,
                          ),

                          const Spacer(),

                          PopUpMenu(
                            items: controller.languages,
                            selectedItem: [controller.selectedLanguage],
                            onTap: controller.selectLanguage,
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),

                /// Logout
                const Item(
                  icon: Icons.logout,
                  title: AppString.logOut,
                  onTap: logOutPopUp,
                ),
              ],
            ),
          );
        },
      ),

      /// Bottom nav
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 3),
    );
  }
}
