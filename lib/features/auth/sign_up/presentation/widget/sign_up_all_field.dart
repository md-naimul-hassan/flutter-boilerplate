import 'package:flutter/material.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/helpers/validation.dart';

class SignUpAllField extends StatelessWidget {
  const SignUpAllField({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.onSubmitted,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        /// User Name here
        const CommonText(text: AppString.fullName, bottom: 8, top: 12),
        CommonTextField(
          hintText: AppString.fullName,
          controller: nameController,
          validator: AppValidation.required,
        ),

        /// User Email here
        const CommonText(text: AppString.email, bottom: 8, top: 12),
        CommonTextField(
          controller: emailController,
          hintText: AppString.email,
          validator: AppValidation.email,
        ),

        /// User Password here
        const CommonText(text: AppString.password, bottom: 8, top: 12),
        CommonTextField(
          controller: passwordController,
          isPassword: true,
          hintText: AppString.password,
          validator: AppValidation.password,
        ),

        /// User Confirm Password here
        const CommonText(text: AppString.confirmPassword, bottom: 8, top: 12),
        CommonTextField(
          controller: confirmPasswordController,
          isPassword: true,
          hintText: AppString.confirmPassword,
          validator: (value) =>
              AppValidation.confirmPassword(value, passwordController),
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
