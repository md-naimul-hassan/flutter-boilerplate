import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/enum.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/screen/error_screen.dart';
import '../../../../core/component/text/common_text.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/privacy_policy_bloc.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrivacyPolicyBloc(sl<SettingRemoteDataSource>())
            ..add(PrivacyPolicyRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.privacyPolicy,
            fontSize: 20,
            fontWeight: .w600,
          ),
        ),
        body: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
          builder: (context, state) => switch (state.status) {
            ApiStatus.initial => const SizedBox.shrink(),
            ApiStatus.loading => const CommonLoader(),
            ApiStatus.failure => ErrorScreen(
              onTap: () => context.read<PrivacyPolicyBloc>().add(
                PrivacyPolicyRequested(),
              ),
            ),
            ApiStatus.success => SingleChildScrollView(
              padding: .symmetric(vertical: 24.h, horizontal: 20.w),
              child: Html(data: state.data.content),
            ),
          },
        ),
      ),
    );
  }
}
