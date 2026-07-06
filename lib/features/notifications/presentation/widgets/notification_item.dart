import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/utils/extension.dart';
import '../../data/model/notification_model.dart';


class NotificationItem extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback? onTap;

  const NotificationItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12.r),
      child: Container(
        margin: .only(bottom: 12.h),
        padding: .all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Icon
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.background,
              child: const Icon(
                Icons.notifications,
                color: AppColors.primaryColor,
              ),
            ),

            12.height,

            /// Content
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          text: item.type,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(width: 8.w),

                      CommonText(
                        text: item.createdAt.checkTime,
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ],
                  ),

                  4.height,

                  /// Message
                  CommonText(text: item.message, fontSize: 13, maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
