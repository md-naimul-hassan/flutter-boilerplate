import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../app/constants/app_colors.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../app/di.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.verifyStatus == ApiStatus.success) {
      AppNavigator.toNamed(AppRoutes.createPassword);
    } else if (state.verifyStatus == ApiStatus.failure) {
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
            text: AppString.forgotPassword,
            fontWeight: .w700,
            fontSize: 24,
          ),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (prev, curr) => prev.verifyStatus != curr.verifyStatus,
          listener: _onStateChanged,
          builder: (context, state) => SingleChildScrollView(
            padding: .symmetric(vertical: 24.h, horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CommonText(
                    text: '${AppString.codeHasBeenSendTo} ${state.email}',
                    fontSize: 18,
                    top: 100,
                    bottom: 60,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    controller: _otpController,
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
                    onSubmitted: (value) {
                      if (value.length == 6) {
                        context.read<ForgotPasswordBloc>().add(
                          ForgotVerifyOtpRequested(_otpController.text.trim()),
                        );
                      }
                    },
                    onChanged: (value) {
                      if (value.length == 6) {
                        context.read<ForgotPasswordBloc>().add(
                          ForgotVerifyOtpRequested(_otpController.text.trim()),
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: state.canResendOtp
                        ? () => context.read<ForgotPasswordBloc>().add(
                            ForgotSendEmailRequested(state.email),
                          )
                        : null,
                    child: CommonText(
                      text: state.canResendOtp
                          ? AppString.resendCode
                          : '${AppString.resendCodeIn} ${state.timerText}',
                      fontSize: 18,
                      top: 60,
                      bottom: 100,
                    ),
                  ),
                  CommonButton(
                    titleText: AppString.verify,
                    isLoading: state.verifyStatus == ApiStatus.loading,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                          ForgotVerifyOtpRequested(_otpController.text.trim()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
