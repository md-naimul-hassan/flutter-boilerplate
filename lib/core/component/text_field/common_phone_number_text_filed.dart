import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_string.dart';


class CommonPhoneNumberTextFiled extends StatelessWidget {
  const CommonPhoneNumberTextFiled({
    super.key,
    required this.controller,
    required this.countryChange,
  });

  final TextEditingController controller;
  final Function(Country value) countryChange;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      onCountryChanged: countryChange,
      decoration: const InputDecoration(
        hintText: AppString.phoneNumber,
        fillColor: AppColors.filledColor,
        filled: true,
        disabledBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
        border: OutlineInputBorder(
          borderSide: .none,
          borderRadius: .all(.circular(8)),
        ),
      ),
      initialCountryCode: 'BD',
    );
  }
}
