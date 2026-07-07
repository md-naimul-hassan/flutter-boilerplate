import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/router.dart';
import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/utils/enum.dart';
import '../../../../../core/utils/app_snackbar.dart';



class ForgetPasswordController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    setValue();
  }

  static ForgetPasswordController get instance =>
      Get.find<ForgetPasswordController>();
  final ApiClient apiClient = DioApiClient();

  void setValue() {
    if (kDebugMode) return;
    emailController.text = 'developernaimul00@gmail.com';
    otpController.text = '123456';
    passwordController.text = 'hello123';
    confirmPasswordController.text = 'hello123';
  }

  bool isLoading = false;
  ForgetPasswordStep currentStep = ForgetPasswordStep.email;
  String forgetPasswordToken = '';
  static const int _otpDurationSeconds = 180;
  int remainingSeconds = 0;
  Timer? _timer;
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool get canResendOtp => remainingSeconds == 0;

  String get timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// ===================== TIMER =====================
  void startOtpTimer() {
    _timer?.cancel();
    remainingSeconds = _otpDurationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        remainingSeconds--;
        update();
      }
    });
  }

  /// ===================== Forget Password Repo =====================
  Future<void> sendForgetPasswordEmail() async {
    return;
    try {
      _setLoading(true);
      final response = await apiClient.post(
        ApiEndPoint.forgotPassword,
        body: {'email': emailController.text.trim()},
      );
      if (response.statusCode == 200) {
        AppSnackbar.success(title: 'Success', message: response.message);
        currentStep = ForgetPasswordStep.otp;
        startOtpTimer();
        Get.toNamed(AppRoutes.verifyEmail);
      } else {
        AppSnackbar.error(
          title: response.statusCode.toString(),
          message: response.message,
        );
      }
    } catch (e, s) {
      debugPrint('❌ sendForgetPasswordEmail error: $e');
      debugPrintStack(stackTrace: s);
      AppSnackbar.error(
        title: 'Error',
        message: 'Failed to send verification email. Please try again.',
      );
    } finally {
      _setLoading(false);
    }
  }

  /// ===================== VERIFY OTP Repo =====================
  Future<void> verifyOtp() async {
    try {
      _setLoading(true);
      final response = await apiClient.post(
        ApiEndPoint.verifyOtp,
        body: {
          'email': emailController.text.trim(),
          'otp': otpController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data['data'] ?? {};
        forgetPasswordToken = data['forgetPasswordToken'] ?? '';

        currentStep = ForgetPasswordStep.resetPassword;
        Get.toNamed(AppRoutes.createPassword);
      } else {
        AppSnackbar.error(title: 'Error', message: response.message);
      }
    } catch (e, s) {
      debugPrint('❌ verifyOtp error: $e');
      debugPrintStack(stackTrace: s);
      AppSnackbar.error(title: 'Error', message: 'OTP verification failed.');
    } finally {
      _setLoading(false);
    }
  }

  /// ===================== RESET PASSWORD Repo =====================
  Future<void> resetPassword() async {
    try {
      _setLoading(true);
      final response = await apiClient.post(
        ApiEndPoint.resetPassword,
        headers: {'Forget-password': 'Forget-password $forgetPasswordToken'},
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );
      if (response.statusCode == 200) {
        AppSnackbar.success(title: 'Success', message: response.message);
        _clearAll();
        Get.offAllNamed(AppRoutes.signIn);
      } else {
        AppSnackbar.error(title: 'Error', message: response.message);
      }
    } catch (e, s) {
      debugPrint('❌ resetPassword error: $e');
      debugPrintStack(stackTrace: s);
      AppSnackbar.error(title: 'Error', message: 'Password reset failed.');
    } finally {
      _setLoading(false);
    }
  }

  /// ===================== HELPERS =====================
  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _clearAll() {
    emailController.clear();
    otpController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _timer?.cancel();
    remainingSeconds = 0;
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
