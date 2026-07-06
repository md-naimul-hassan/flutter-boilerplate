import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/button/common_button.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/storeage/storage_services.dart';
import '../../../../app/constants/app_images.dart';
import '../../../../core/utils/extension.dart';
import '../controller/profile_controller.dart';
import '../widgets/edit_profile_all_filed.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        final userImage = LocalStorage.user.image;

        return Scaffold(
          /// AppBar
          appBar: AppBar(
            centerTitle: true,
            title: const CommonText(
              text: AppString.profile,
              fontSize: 20,
              fontWeight: .w600,
            ),
          ),

          /// Body
          body: SingleChildScrollView(
            padding: .symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Profile image
                  Stack(
                    alignment: .bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 70.r,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: controller.image != null
                              ? Image.file(
                                  File(controller.image!),
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                )
                              : CommonImage(
                                  imageSrc: userImage.isEmpty
                                      ? AppImages.profile
                                      : userImage,
                                  width: 140,
                                  height: 140,
                                ),
                        ),
                      ),

                      /// Edit icon
                      IconButton(
                        onPressed: controller.getProfileImage,
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  24.height,

                  /// Fields
                  EditProfileAllFiled(controller: controller),

                  30.height,

                  /// Save button
                  CommonButton(
                    titleText: AppString.saveAndChanges,
                    isLoading: controller.isLoading,
                    onTap: controller.editProfileRepo,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
