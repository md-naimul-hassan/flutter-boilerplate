import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/router.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../domain/usecases/sign_in_usecase.dart';

class SignInController extends GetxController {
  final SignInUseCase _signIn;

  SignInController(this._signIn);

  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> submit() async {
    if (isLoading) return;

    isLoading = true;
    update();

    try {
      await _signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emailController.clear();
      passwordController.clear();
      Get.offAllNamed(AppRoutes.profile);
    } on ApiException catch (e) {
      AppSnackbar.error(title: e.statusCode.toString(), message: e.message);
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
