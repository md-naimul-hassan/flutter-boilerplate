import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/html_model.dart';
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/utils/app_snackbar.dart';

class PrivacyPolicyController extends GetxController {
  /// API status
  Status status = Status.completed;

  /// HTML data
  HtmlModel data = HtmlModel.fromJson({});

  /// Instance (for lazyPut/bindings)
  static PrivacyPolicyController get instance =>
      Get.find<PrivacyPolicyController>();

  final ApiClient apiClient = DioApiClient();

  /// Fetch privacy policy
  Future<void> getPrivacyPolicy() async {
    return;
    try {
      status = Status.loading;
      update();

      final response = await apiClient.get(ApiEndPoint.privacyPolicies);

      if (response.statusCode != 200) {
        throw Exception(response.message);
      }

      final Map<String, dynamic> rawData = response.data['data'] ?? {};
      final Map<String, dynamic> raw = rawData['attributes'] ?? {};

      data = HtmlModel.fromJson(raw);

      status = Status.completed;
    } catch (e) {
      status = Status.error;
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPrivacyPolicy();
  }
}
