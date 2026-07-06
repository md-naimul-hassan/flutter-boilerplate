import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import '../../../../../app/router.dart';
import '../../../../../app/constants/api_end_point.dart';

import '../../../../../core/services/api/api_client.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/storeage/storage_services.dart';
import '../../../../../core/utils/helpers/other_helper.dart';
import '../../../../../core/utils/app_snackbar.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();

  final ApiClient apiClient = DioApiClient();

  bool isLoading = false;
  bool isLoadingVerify = false;
  String selectRole = 'User';
  String countryCode = '+880';
  String? image;
  String signUpToken = '';
  Timer? _timer;
  int _seconds = 0;

  /// Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();
  final otpController = TextEditingController();

  /// Get formatted timer text (mm:ss)
  String get time {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Change selected country
  void onCountryChange(Country value) {
    countryCode = value.dialCode;
  }

  /// Change role
  void setSelectedRole(String value) {
    selectRole = value;
    update();
  }

  /// Pick image from gallery
  Future<void> openGallery() async {
    image = await OtherHelper.pickImage();
    update();
  }

  /// Set loading state
  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  /// Set verify loading state
  void _setVerifyLoading(bool value) {
    isLoadingVerify = value;
    update();
  }

  /// Sign up user API call
  Future<void> signUpUser() async {
    Get.toNamed(AppRoutes.verifyUser);
    return;
    try {
      _setLoading(true);

      final body = {
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': numberController.text.trim(),
        'countryCode': countryCode,
        'password': passwordController.text.trim(),
        'role': selectRole.toLowerCase(),
      };

      final response = await apiClient.post(ApiEndPoint.signUp, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? {};
        signUpToken = data['signUpToken'] ?? '';

        Get.toNamed(AppRoutes.verifyUser);
      } else {
        AppSnackbar.error(
          title: response.statusCode.toString(),
          message: response.message,
        );
      }
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Start OTP countdown timer (3 minutes)
  void startTimer() {
    _timer?.cancel();
    _seconds = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        return;
      }
      _seconds--;
      update();
    });
  }

  /// Verify OTP API call
  Future<void> verifyOtp() async {
    Get.offAllNamed(AppRoutes.signIn);
    return;
    try {
      _setVerifyLoading(true);
      final body = {'otp': otpController.text};
      final headers = {'SignUpToken': 'signUpToken $signUpToken'};
      final response = await apiClient.post(
        ApiEndPoint.verifyEmail,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? {};

        LocalStorage.saveToken(data['accessToken']);
        LocalStorage.saveRefreshToken(data['refreshToken']);
        LocalStorage.saveUser(data['user']);

        Get.offAllNamed(AppRoutes.signIn);
      } else {
        Get.snackbar(response.statusCode.toString(), response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      _setVerifyLoading(false);
    }
  }

  /// Dispose controllers & timer
  @override
  void onClose() {
    _timer?.cancel();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    numberController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
