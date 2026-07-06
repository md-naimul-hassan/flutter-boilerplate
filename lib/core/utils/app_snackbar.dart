import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success({required String title, required String message}) {
    _showSnackbar(
      title: kDebugMode ? title : 'Success',
      message: message,
      backgroundColor: AppColors.black,
      position: .BOTTOM,
    );
  }

  static void error({String? title, required String message}) {
    _showSnackbar(
      title: kDebugMode ? (title ?? 'Error') : 'Oops',
      message: message,
      backgroundColor: AppColors.red,
      position: .TOP,
    );
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required SnackPosition position,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: AppColors.white,
      backgroundColor: backgroundColor,
      snackPosition: position,
      margin: const .all(12),
      borderRadius: 8,
    );
  }
}
