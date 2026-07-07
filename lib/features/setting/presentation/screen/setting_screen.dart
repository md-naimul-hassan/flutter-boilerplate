import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/enum.dart';
import '../../../../app/router.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/pop_up/common_pop_menu.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../bloc/setting_bloc.dart';
import '../widgets/setting_item.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onStateChanged(BuildContext context, SettingState state) {
    if (state.status == ApiStatus.success) {
      _passwordController.clear();
      AppNavigator.offAllNamed(AppRoutes.signIn);
    } else if (state.status == ApiStatus.failure) {
      AppSnackbar.error(message: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingBloc(sl<ApiClient>()),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.settings,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: BlocConsumer<SettingBloc, SettingState>(
          listener: _onStateChanged,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: .symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  SettingItem(
                    title: AppString.changePassword,
                    iconData: Icons.lock_outline,
                    onTap: () => AppNavigator.toNamed(AppRoutes.changePassword),
                  ),
                  SettingItem(
                    title: AppString.termsOfServices,
                    iconData: Icons.gavel,
                    onTap: () =>
                        AppNavigator.toNamed(AppRoutes.termsOfServices),
                  ),
                  SettingItem(
                    title: AppString.privacyPolicy,
                    iconData: Icons.privacy_tip_outlined,
                    onTap: () => AppNavigator.toNamed(AppRoutes.privacyPolicy),
                  ),
                  SettingItem(
                    title: AppString.deleteAccount,
                    iconData: Icons.delete_outline_rounded,
                    textColor: Colors.red,
                    onTap: () => deletePopUp(
                      controller: _passwordController,
                      isLoading: state.status == ApiStatus.loading,
                      onTap: () => context.read<SettingBloc>().add(
                        SettingDeleteAccountRequested(_passwordController.text),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const CommonBottomNavBar(currentIndex: 0),
      ),
    );
  }
}
