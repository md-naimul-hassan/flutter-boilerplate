import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/component/button/common_button.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../app/di.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../app/constants/app_colors.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';
import '../widgets/do_not_have_account.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, SignInState state) {
    if (state.status == ApiStatus.success) {
      _emailController.clear();
      _passwordController.clear();
      AppNavigator.offAllNamed(AppRoutes.profile);
    } else if (state.status == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(sl<SignInRemoteDataSource>()),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: _onStateChanged,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: .symmetric(horizontal: 20.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const CommonText(
                      text: AppString.logIntoYourAccount,
                      fontSize: 32,
                      bottom: 20,
                      top: 36,
                    ),
                    const CommonText(text: AppString.email, bottom: 8),
                    CommonTextField(
                      controller: _emailController,
                      hintText: AppString.email,
                      validator: AppValidation.email,
                    ),
                    const CommonText(
                      text: AppString.password,
                      bottom: 8,
                      top: 24,
                    ),
                    CommonTextField(
                      controller: _passwordController,
                      isPassword: true,
                      hintText: AppString.password,
                      validator: AppValidation.password,
                      onSubmitted: (_) {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<SignInBloc>().add(
                          SignInSubmitted(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: .centerRight,
                      child: InkWell(
                        onTap: () =>
                            AppNavigator.toNamed(AppRoutes.forgotPassword),
                        child: const CommonText(
                          text: AppString.forgotThePassword,
                          top: 10,
                          bottom: 30,
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                    CommonButton(
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<SignInBloc>().add(
                          SignInSubmitted(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          ),
                        );
                      },
                      isLoading: state.status == ApiStatus.loading,
                      titleText: AppString.signIn,
                    ),
                    30.height,
                    const DoNotHaveAccount(),
                    30.height,
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
