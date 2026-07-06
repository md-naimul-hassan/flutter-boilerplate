import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/text/common_text.dart';
import '../../../../app/constants/app_colors.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    required this.iconData,
    this.onTap,
    this.textColor = AppColors.secondary,
    this.backgroundColor = AppColors.blueLight,
  });

  final String title;
  final IconData iconData;
  final VoidCallback? onTap;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(4.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.r),
        onTap: onTap,
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            children: [
              /// Icon
              Icon(iconData, color: textColor),

              SizedBox(width: 12.w),

              /// Title
              Expanded(
                child: CommonText(text: title, color: textColor),
              ),

              /// Arrow
              Icon(Icons.arrow_forward_ios, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
