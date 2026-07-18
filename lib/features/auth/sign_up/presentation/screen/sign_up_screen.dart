import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../app/di.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/extension.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/state.dart';
import '../widget/already_account_rich_text.dart';
import '../widget/sign_up_all_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, SignUpState state) {
    if (state.signUpStatus == ApiStatus.success) {
      AppNavigator.push(AppRoutes.verifyUser);
    } else if (state.signUpStatus == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SignUpBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listenWhen: (prev, curr) => prev.signUpStatus != curr.signUpStatus,
          listener: _onStateChanged,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: .symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CommonText(
                      text: AppString.createYourAccount,
                      fontSize: 32,
                      bottom: 20,
                    ),
                    SignUpAllField(
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onSubmitted: (_) {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<SignUpBloc>().add(
                          SignUpSubmitted(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                    16.height,
                    CommonButton(
                      titleText: AppString.signUp,
                      isLoading: state.signUpStatus == ApiStatus.loading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<SignUpBloc>().add(
                          SignUpSubmitted(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                    ),
                    24.height,
                    const AlreadyAccountRichText(),
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
