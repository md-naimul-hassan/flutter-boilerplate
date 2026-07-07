import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/constants/app_colors.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../app/enum.dart';
import '../../../../../app/router.dart';
import '../../../../../app/di.dart';
import '../../../../../core/component/button/common_button.dart';
import '../../../../../core/component/text/common_text.dart';
import '../../../../../core/component/text_field/common_text_field.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/utils/extension.dart';
import '../../../../../core/utils/helpers/validation.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/events.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, ChangePasswordState state) {
    if (state.status == ApiStatus.success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      AppSnackbar.success(title: 'Success', message: state.message);
      AppNavigator.back();
    } else if (state.status == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChangePasswordBloc(sl<ChangePasswordRemoteDataSource>()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CommonText(
            text: AppString.changePassword,
            fontSize: 20,
            fontWeight: .w600,
          ),
        ),
        body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: _onStateChanged,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: .symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    70.height,

                    /// current Password section
                    const CommonText(
                      text: AppString.currentPassword,
                      bottom: 8,
                    ),
                    CommonTextField(
                      controller: _currentPasswordController,
                      hintText: AppString.currentPassword,
                      validator: AppValidation.password,
                      isPassword: true,
                    ),

                    /// New Password section
                    const CommonText(
                      text: AppString.newPassword,
                      bottom: 8,
                      top: 16,
                    ),
                    CommonTextField(
                      controller: _newPasswordController,
                      hintText: AppString.newPassword,
                      validator: AppValidation.password,
                      isPassword: true,
                    ),

                    /// confirm Password section
                    const CommonText(
                      text: AppString.confirmPassword,
                      bottom: 8,
                      top: 16,
                    ),
                    CommonTextField(
                      controller: _confirmPasswordController,
                      hintText: AppString.confirmPassword,
                      validator: (value) => AppValidation.confirmPassword(
                        value,
                        _newPasswordController,
                      ),
                      isPassword: true,
                    ),

                    /// forget Password button
                    Align(
                      alignment: .centerLeft,
                      child: InkWell(
                        onTap: () =>
                            AppNavigator.toNamed(AppRoutes.forgotPassword),
                        child: CommonText(
                          text: AppString.forgotPassword,
                          color: AppColors.primaryColor,
                          fontWeight: .w600,
                          fontSize: 18.sp,
                          top: 16.h,
                          bottom: 20.h,
                        ),
                      ),
                    ),

                    /// submit Button
                    CommonButton(
                      titleText: AppString.confirm,
                      isLoading: state.status == ApiStatus.loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ChangePasswordBloc>().add(
                            ChangePasswordSubmitted(
                              oldPassword: _currentPasswordController.text,
                              newPassword: _newPasswordController.text,
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
