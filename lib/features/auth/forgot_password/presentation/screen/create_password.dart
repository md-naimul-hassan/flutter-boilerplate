import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/app_images.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../app/di.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/image/common_image.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.resetStatus == ApiStatus.success) {
      AppSnackbar.success(title: 'Success', message: state.message);
      AppNavigator.go(AppRoutes.signIn);
    } else if (state.resetStatus == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ForgotPasswordBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.createNewPassword,
            fontWeight: .w700,
            fontSize: 24,
          ),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (prev, curr) => prev.resetStatus != curr.resetStatus,
          listener: _onStateChanged,
          builder: (context, state) {
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
                      controller: _passwordController,
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
                      controller: _confirmPasswordController,
                      hintText: AppString.confirmPassword,
                      validator: (value) => AppValidation.confirmPassword(
                        value,
                        _passwordController,
                      ),
                      isPassword: true,
                    ),
                    64.height,
                    CommonButton(
                      titleText: AppString.continues,
                      isLoading: state.resetStatus == ApiStatus.loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotResetPasswordRequested(
                              _passwordController.text.trim(),
                              _confirmPasswordController.text.trim(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
