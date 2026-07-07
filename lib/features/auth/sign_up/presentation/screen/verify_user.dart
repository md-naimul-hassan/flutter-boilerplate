import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../app/di.dart';
import '../../../../../app/constants/app_colors.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sl<SignUpBloc>().add(SignUpTimerStarted());
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, SignUpState state) {
    if (state.verifyStatus == ApiStatus.success) {
      AppNavigator.offAllNamed(AppRoutes.signIn);
    } else if (state.verifyStatus == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SignUpBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.otpVerify,
            fontWeight: .w700,
            fontSize: 24,
          ),
        ),
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listenWhen: (prev, curr) => prev.verifyStatus != curr.verifyStatus,
          listener: _onStateChanged,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: .symmetric(vertical: 24.h, horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: CommonText(
                        text: '${AppString.codeHasBeenSendTo} ${state.email}',
                        fontSize: 18,
                        top: 100,
                        bottom: 60,
                        maxLines: 3,
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: PinCodeTextField(
                        controller: _otpController,
                        autoDisposeControllers: false,
                        cursorColor: AppColors.black,
                        appContext: context,
                        autoFocus: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(16.r),
                          fieldHeight: 60.h,
                          fieldWidth: 60.w,
                          activeFillColor: AppColors.transparent,
                          selectedFillColor: AppColors.transparent,
                          inactiveFillColor: AppColors.transparent,
                          borderWidth: 0.5.w,
                          selectedColor: AppColors.primaryColor,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: AppColors.black,
                        ),
                        length: 6,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        enableActiveFill: true,
                        validator: (value) {
                          if (value != null && value.length == 6) {
                            return null;
                          }
                          return AppString.otpIsInValid;
                        },
                        onChanged: (value) {
                          if (value.length == 6) {
                            context.read<SignUpBloc>().add(
                              SignUpOtpSubmitted(_otpController.text),
                            );
                          }
                        },
                        onSubmitted: (value) {
                          if (value.length == 6) {
                            context.read<SignUpBloc>().add(
                              SignUpOtpSubmitted(_otpController.text),
                            );
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: state.time == '00:00'
                          ? () => context.read<SignUpBloc>().add(
                              SignUpResendRequested(),
                            )
                          : () {},
                      child: CommonText(
                        text: state.time == '00:00'
                            ? AppString.resendCode
                            : '${AppString.resendCodeIn} ${state.time} ${AppString.minute}',
                        top: 60,
                        bottom: 100,
                        fontSize: 18,
                      ),
                    ),
                    CommonButton(
                      titleText: AppString.verify,
                      isLoading: state.verifyStatus == ApiStatus.loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignUpBloc>().add(
                            SignUpOtpSubmitted(_otpController.text),
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
