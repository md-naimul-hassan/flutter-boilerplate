import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/screen/error_screen.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/utils/enum.dart';
import '../../data/datasources/remote_data_source.dart';
import '../bloc/terms_of_services_bloc.dart';

class TermsOfServicesScreen extends StatelessWidget {
  const TermsOfServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TermsOfServicesBloc(sl<SettingRemoteDataSource>())
            ..add(TermsOfServicesRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: AppString.termsOfServices,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: BlocBuilder<TermsOfServicesBloc, TermsOfServicesState>(
          builder: (context, state) => switch (state.status) {
            Status.loading => const CommonLoader(),
            Status.error => ErrorScreen(
              onTap: () => context.read<TermsOfServicesBloc>().add(
                TermsOfServicesRequested(),
              ),
            ),
            Status.completed => SingleChildScrollView(
              padding: .symmetric(vertical: 24.h, horizontal: 20.w),
              child: Html(data: state.data.content),
            ),
          },
        ),
      ),
    );
  }
}
