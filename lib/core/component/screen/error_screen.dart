import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_string.dart';
import '../../utils/extension.dart';


class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          20.height,
          const Text(
            AppString.somethingIsWrong,
            style: TextStyle(
              fontWeight: .w500,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          20.height,
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(MediaQuery.of(context).size.width / 1.6, 40),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
              ),
            ),
            child: const Text(
              AppString.tryAgain,
              style: TextStyle(
                fontSize: 18,
                fontWeight: .w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
