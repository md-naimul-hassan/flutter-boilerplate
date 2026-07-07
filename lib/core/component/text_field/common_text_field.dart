import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/constants/app_colors.dart';
import '../text/common_text.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
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
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool _obscureText = false;

  void _toggle() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: .onUnfocus,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.isPassword ? !_obscureText : _obscureText,
      textInputAction: widget.textInputAction,
      maxLength: widget.mexLength,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(fontSize: 14, color: widget.textColor),
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      decoration: InputDecoration(
        errorMaxLines: 2,
        isDense: widget.isDense,
        filled: true,
        prefixIconConstraints: const BoxConstraints(
          maxWidth: 30,
          maxHeight: 30,
        ),
        prefixIcon: widget.prefixIcon,
        fillColor: widget.fillColor,

        counterText: '',
        contentPadding: .symmetric(
          horizontal: widget.paddingHorizontal.w,
          vertical: widget.paddingVertical.h,
        ),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        disabledBorder: _buildBorder(),
        errorBorder: _buildBorder(),
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: GoogleFonts.roboto(fontSize: 14, color: widget.hintTextColor),
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          color: widget.labelTextColor,
        ),
        prefix: CommonText(text: widget.prefixText ?? '', fontWeight: .w400),
        suffixIcon: widget.isPassword
            ? _buildPasswordSuffixIcon()
            : widget.suffixIcon,
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: .circular(widget.borderRadius.r),
      borderSide: BorderSide(
        color: widget.borderColor == AppColors.transparent
            ? Colors.grey.withValues(alpha: 0.3)
            : widget.borderColor,
      ),
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return GestureDetector(
      onTap: _toggle,
      child: Padding(
        padding: .only(right: 10.w),
        child: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20.sp,
          color: widget.textColor,
        ),
      ),
    );
  }
}
