import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../controller/forget_password_controller.dart';


class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      builder: (controller) => Scaffold(
        /// App Bar Section
        appBar: AppBar(
          title: const CommonText(
            text: AppString.forgotPassword,
            fontWeight: .w700,
            fontSize: 24,
          ),
        ),

        /// body section
        body: SingleChildScrollView(
          padding: .symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                /// forget password take email for reset Password
                const CommonText(text: AppString.email, bottom: 8, top: 80),
                CommonTextField(
                  controller: controller.emailController,
                  hintText: AppString.email,
                  validator: AppValidation.email,
                ),
                100.height,
              ],
            ),
          ),
        ),

        /// Bottom Navigation Bar Section
        bottomNavigationBar: Padding(
          padding: const .symmetric(vertical: 30, horizontal: 20),

          /// Submit Button
          child: CommonButton(
            titleText: AppString.continues,
            isLoading: controller.isLoading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                controller.sendForgetPasswordEmail();
              }
            },
          ),
        ),
      ),
    );
  }
}
