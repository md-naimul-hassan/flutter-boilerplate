import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../app/router.dart';
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/services/api/api_client.dart';
import '../../../../core/services/api/api_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class SettingController extends GetxController {
  /// Password input

  bool isLoading = false;
  final TextEditingController passwordController = TextEditingController();
  final ApiClient apiClient = DioApiClient();

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  /// Delete account
  Future<void> deleteAccount() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      AppSnackbar.error(title: 'Error', message: 'Password required');
      return;
    }

    return;
    try {
      _setLoading(true);

      final body = {'password': password};

      final response = await apiClient.delete(ApiEndPoint.user, body: body);

      if (response.statusCode != 200) {
        throw Exception(response.message);
      }

      passwordController.clear();
      Get.offAllNamed(AppRoutes.signIn);
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Dispose controller
  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
