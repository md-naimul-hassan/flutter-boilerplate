import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../app/constants/app_string.dart';
import '../../../../../app/router.dart';
import '../../../../../app/constants/app_colors.dart';


class AlreadyAccountRichText extends StatelessWidget {
  const AlreadyAccountRichText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          /// Already Have Account
          TextSpan(
            text: AppString.alreadyHaveAccount,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: .w500,
            ),
          ),

          /// Sign In Button Here
          TextSpan(
            text: AppString.signIn,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(AppRoutes.signIn);
              },
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
