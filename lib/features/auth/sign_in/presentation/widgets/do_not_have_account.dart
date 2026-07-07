import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../app/constants/app_string.dart';
import '../../../../../app/router.dart';
import '../../../../../app/constants/app_colors.dart';


class DoNotHaveAccount extends StatelessWidget {
  const DoNotHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: AppString.doNotHaveAccount,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: AppString.signUp,
            recognizer: TapGestureRecognizer()
              ..onTap = () => AppNavigator.toNamed(AppRoutes.signUp),
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
