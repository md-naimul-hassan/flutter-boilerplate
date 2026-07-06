import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../core/services/api/api_client.dart';
import '../../../../../app/constants/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_snackbar.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final ApiClient apiClient = DioApiClient();

  ///  change password function
  Future<void> changePasswordRepo() async {
    Get.back();
    return;
    isLoading = true;
    update();
    final Map<String, String> body = {
      'oldPassword': currentPasswordController.text,
      'newPassword': newPasswordController.text,
    };
    final response = await apiClient.patch(
      ApiEndPoint.changePassword,
      body: body,
    );

    if (response.statusCode == 200) {
      AppSnackbar.success(
        title: response.statusCode.toString(),
        message: response.message,
      );

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }
    isLoading = false;
    update();
  }

  /// dispose Controller
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
