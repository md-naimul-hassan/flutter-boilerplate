import 'package:flutter/material.dart';

import '../../../app/constants/app_string.dart';


class AppValidation {
  AppValidation._();

  static final emailRegexp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  static final passRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.thisFieldIsRequired;
    }
    return null;
  }

  static String? email(String? value) {
    final error = required(value);
    if (error != null) return error;

    if (!emailRegexp.hasMatch(value!)) {
      return AppString.enterValidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    final error = required(value);
    if (error != null) return error;
    if (!passRegExp.hasMatch(value!)) {
      return AppString.passwordMustBeeEightCharacters;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    TextEditingController passwordController,
  ) {
    final error = required(value);
    if (error != null) return error;

    if (value != passwordController.text) {
      return AppString.thePasswordDoesNotMatch;
    }
    return null;
  }
}
