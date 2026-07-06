import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/screen/error_screen.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/utils/enum.dart';
import '../controller/terms_of_services_controller.dart';


class TermsOfServicesScreen extends StatelessWidget {
  const TermsOfServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        title: const CommonText(
          text: AppString.termsOfServices,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      /// Body
      body: GetBuilder<TermsOfServicesController>(
        builder: (controller) => switch (controller.status) {
          /// Loading
          Status.loading => const CommonLoader(),

          /// Error
          Status.error => ErrorScreen(onTap: controller.getTermsOfServices),

          /// Completed
          Status.completed => SingleChildScrollView(
            padding: .symmetric(vertical: 24.h, horizontal: 20.w),
            child: Html(data: controller.data.content),
          ),
        },
      ),
    );
  }
}
