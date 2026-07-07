import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/constants/app_string.dart';
import '../../../../../app/di.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state.sendStatus == ApiStatus.success) {
      AppSnackbar.success(title: 'Success', message: state.message);
      AppNavigator.toNamed(AppRoutes.verifyEmail);
    } else if (state.sendStatus == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ForgotPasswordBloc>(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (prev, curr) => prev.sendStatus != curr.sendStatus,
        listener: _onStateChanged,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const CommonText(
              text: AppString.forgotPassword,
              fontWeight: .w700,
              fontSize: 24,
            ),
          ),
          body: SingleChildScrollView(
            padding: .symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const CommonText(text: AppString.email, bottom: 8, top: 80),
                  CommonTextField(
                    controller: _emailController,
                    hintText: AppString.email,
                    validator: AppValidation.email,
                    onSubmitted: (_) {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordBloc>().add(
                          ForgotSendEmailRequested(
                            _emailController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  100.height,
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const .symmetric(vertical: 30, horizontal: 20),
            child: CommonButton(
              titleText: AppString.continues,
              isLoading: state.sendStatus == ApiStatus.loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ForgotPasswordBloc>().add(
                    ForgotSendEmailRequested(_emailController.text.trim()),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
