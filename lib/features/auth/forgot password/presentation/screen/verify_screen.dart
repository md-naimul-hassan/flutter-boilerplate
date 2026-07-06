import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../app/constants/app_colors.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../controller/forget_password_controller.dart';


class VerifyScreen extends StatelessWidget {
  VerifyScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: AppString.forgotPassword,
          fontWeight: .w700,
          fontSize: 24,
        ),
      ),
      body: GetBuilder<ForgetPasswordController>(
        builder: (controller) => SingleChildScrollView(
          padding: .symmetric(vertical: 24.h, horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Instruction text
                CommonText(
                  text:
                      '${AppString.codeHasBeenSendTo} ${controller.emailController.text}',
                  fontSize: 18,
                  top: 100,
                  bottom: 60,
                ),

                /// OTP Field
                PinCodeTextField(
                  appContext: context,
                  controller: controller.otpController,
                  length: 6,
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  autoDisposeControllers: false,
                  cursorColor: AppColors.black,
                  validator: (value) {
                    if (value != null && value.length == 6) return null;
                    return AppString.otpIsInValid;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 60.h,
                    fieldWidth: 60.w,
                    borderWidth: 0.5.w,
                    selectedColor: AppColors.primaryColor,
                    activeColor: AppColors.primaryColor,
                    inactiveColor: AppColors.black,
                    activeFillColor: AppColors.transparent,
                    selectedFillColor: AppColors.transparent,
                    inactiveFillColor: AppColors.transparent,
                  ),
                  enableActiveFill: true,
                ),

                /// Resend section
                TextButton(
                  onPressed: controller.canResendOtp
                      ? () => controller.sendForgetPasswordEmail()
                      : null,
                  child: CommonText(
                    text: controller.canResendOtp
                        ? AppString.resendCode
                        : '${AppString.resendCodeIn} ${controller.timerText}',
                    fontSize: 18,
                    top: 60,
                    bottom: 100,
                  ),
                ),

                /// Verify button
                CommonButton(
                  titleText: AppString.verify,
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.verifyOtp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
