import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppSnackbar {
  AppSnackbar._();

  static void success({required String title, required String message}) {
    _show(
      title: kDebugMode ? title : 'Success',
      message: message,
      backgroundColor: AppColors.black,
    );
  }

  static void error({String? title, required String message}) {
    _show(
      title: kDebugMode ? (title ?? 'Error') : 'Oops',
      message: message,
      backgroundColor: AppColors.red,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(message, style: const TextStyle(color: AppColors.white)),
            ],
          ),
        ),
      );
  }
}
