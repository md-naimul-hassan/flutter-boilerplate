import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../app/constants/app_images.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../controller/forget_password_controller.dart';


class CreatePassword extends StatelessWidget {
  CreatePassword({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar Section starts here
      appBar: AppBar(
        title: const CommonText(
          text: AppString.createNewPassword,
          fontWeight: .w700,
          fontSize: 24,
        ),
      ),

      /// Body Section starts here
      body: GetBuilder<ForgetPasswordController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: .symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  64.height,
                  const CommonImage(
                    imageSrc: AppImages.noImage,
                    size: 297,
                  ).center,

                  const CommonText(
                    text: AppString.createYourNewPassword,
                    fontSize: 18,
                    textAlign: .start,
                    top: 64,
                    bottom: 24,
                  ),

                  const CommonText(text: AppString.password, bottom: 8),
                  CommonTextField(
                    controller: controller.passwordController,
                    hintText: AppString.password,
                    isPassword: true,
                    validator: AppValidation.password,
                  ),

                  const CommonText(
                    text: AppString.password,
                    bottom: 8,
                    top: 12,
                  ),
                  CommonTextField(
                    controller: controller.confirmPasswordController,
                    hintText: AppString.confirmPassword,
                    validator: (value) => AppValidation.confirmPassword(
                      value,
                      controller.passwordController,
                    ),
                    isPassword: true,
                  ),

                  64.height,
                  CommonButton(
                    titleText: AppString.continues,
                    isLoading: controller.isLoading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
