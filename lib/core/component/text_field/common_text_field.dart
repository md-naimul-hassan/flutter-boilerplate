import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/constants/app_colors.dart';
import '../text/common_text.dart';

// ignore: must_be_immutable
class CommonTextField extends StatelessWidget {
  CommonTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.mexLength,
    this.validator,
    this.prefixText,
    this.paddingHorizontal = 16,
    this.paddingVertical = 14,
    this.borderRadius = 10,
    this.inputFormatters,
    this.fillColor = AppColors.white,
    this.hintTextColor = AppColors.textFiledColor,
    this.labelTextColor = AppColors.textFiledColor,
    this.textColor = AppColors.black,
    this.borderColor = AppColors.transparent,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.isDense,
    this.suffixIcon,
    this.maxLines,
  });

  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color borderColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final int? maxLines;
  final double borderRadius;
  final int? mexLength;
  final bool isPassword;
  final bool? isDense;
  RxBool obscureText = false.obs;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        autovalidateMode: .onUnfocus,
        keyboardType: keyboardType,
        controller: controller,
        obscureText: isPassword ? !obscureText.value : obscureText.value,
        textInputAction: textInputAction,
        maxLength: mexLength,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: TextStyle(fontSize: 14, color: textColor),
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        validator: validator,
        maxLines: isPassword ? 1 : maxLines,
        decoration: InputDecoration(
          errorMaxLines: 2,
          isDense: isDense,
          filled: true,
          prefixIconConstraints: const BoxConstraints(
            maxWidth: 30,
            maxHeight: 30,
          ),
          prefixIcon: prefixIcon,
          fillColor: fillColor,

          counterText: '',
          contentPadding: .symmetric(
            horizontal: paddingHorizontal.w,
            vertical: paddingVertical.h,
          ),
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildBorder(),
          disabledBorder: _buildBorder(),
          errorBorder: _buildBorder(),
          hintText: hintText,
          labelText: labelText,
          hintStyle: GoogleFonts.roboto(fontSize: 14, color: hintTextColor),
          labelStyle: GoogleFonts.roboto(fontSize: 14, color: labelTextColor),
          prefix: CommonText(text: prefixText ?? '', fontWeight: .w400),
          suffixIcon: isPassword ? _buildPasswordSuffixIcon() : suffixIcon,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: .circular(borderRadius.r),
      borderSide: BorderSide(
        color: borderColor == AppColors.transparent
            ? Colors.grey.withValues(alpha: 0.3)
            : borderColor,
      ),
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return GestureDetector(
      onTap: toggle,
      child: Padding(
        padding: .only(right: 10.w),
        child: Obx(
          () => Icon(
            obscureText.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20.sp,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void toggle() {
    obscureText.value = !obscureText.value;
  }
}
