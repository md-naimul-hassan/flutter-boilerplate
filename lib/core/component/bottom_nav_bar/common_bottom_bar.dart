import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router.dart';
import '../../../app/constants/app_colors.dart';
import '../../utils/logger.dart';

final List<Widget> _unselectedIcons = [
  const Icon(Icons.settings_outlined, color: AppColors.black),
  const Icon(Icons.notifications_outlined, color: AppColors.black),
  const Icon(Icons.chat, color: AppColors.black),
  const Icon(Icons.person_2_outlined, color: AppColors.black),
];

final List<Widget> _selectedIcons = [
  const Icon(Icons.settings_outlined, color: AppColors.primaryColor),
  const Icon(Icons.notifications, color: AppColors.primaryColor),
  const Icon(Icons.chat, color: AppColors.primaryColor),
  const Icon(Icons.person, color: AppColors.primaryColor),
];

class CommonBottomNavBar extends StatelessWidget {
  const CommonBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      alignment: .center,
      padding: .all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: .only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: List.generate(_unselectedIcons.length, (index) {
          return InkWell(
            onTap: () => onTap(index),
            child: Container(
              margin: .all(12.sp),
              child: Column(
                children: [
                  index == currentIndex
                      ? _selectedIcons[index]
                      : _unselectedIcons[index],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> onTap(int index) async {
    logInfo(currentIndex);

    if (index == currentIndex) return;
    switch (index) {
      case 0:
        AppNavigator.push(AppRoutes.setting);
        break;

      case 1:
        AppNavigator.push(AppRoutes.notifications);
        break;

      case 2:
        AppNavigator.push(AppRoutes.chat);
        break;

      case 3:
        AppNavigator.push(AppRoutes.profile);
        break;

      default:
        logError('Invalid bottom bar index: $index');
    }
  }
}
