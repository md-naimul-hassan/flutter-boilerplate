import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/other_widgets/no_data.dart';
import '../../../../core/component/text/common_text.dart';
import '../controller/notifications_controller.dart';
import '../../data/model/notification_model.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar
      appBar: AppBar(
        title: CommonText(
          text: AppString.notifications,
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
        ),
      ),

      /// Body
      body: GetBuilder<NotificationsController>(
        builder: (controller) {
          /// Loading
          if (controller.isLoading) {
            return const CommonLoader();
          }

          /// Empty
          if (controller.notifications.isEmpty) {
            return const NoData();
          }

          /// List
          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView.builder(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: controller.isLoadingMore
                  ? controller.notifications.length + 1
                  : controller.notifications.length,
              itemBuilder: (_, index) {
                /// bottom loader
                if (index >= controller.notifications.length) {
                  return const Padding(
                    padding: .all(12),
                    child: CommonLoader(size: 30, strokeWidth: 2),
                  );
                }

                final NotificationModel item = controller.notifications[index];

                return NotificationItem(item: item);
              },
            ),
          );
        },
      ),

      /// Bottom nav
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 1),
    );
  }
}
