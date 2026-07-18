import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../other_widgets/common_loader.dart';
import '../text/common_text.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final Color? borderColor;
  final double borderWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double buttonWidth;
  final bool isLoading;

  const CommonButton({
    this.onTap,
    required this.titleText,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.titleSize = 16,
    this.buttonRadius = 10,
    this.titleWeight = FontWeight.w700,
    this.buttonHeight = 48,
    this.borderWidth = 1,
    this.isLoading = false,
    this.buttonWidth = double.infinity,
    this.borderColor = AppColors.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildElevatedButton();
  }

  Widget _buildElevatedButton() {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            side: BorderSide(
              color: borderColor ?? buttonColor,
              width: borderWidth,
            ),
          ),
        ),
        child: isLoading ? _buildLoader() : _buildText(),
      ),
    );
  }

  Widget _buildLoader() {
    return CommonLoader(size: buttonHeight - 12);
  }

  Widget _buildText() {
    return CommonText(
      text: titleText,
      fontSize: titleSize,
      color: titleColor,
      fontWeight: titleWeight,
    );
  }
}
