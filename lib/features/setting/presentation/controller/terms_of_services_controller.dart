import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/html_model.dart';
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/utils/app_snackbar.dart';

class TermsOfServicesController extends GetxController {
  /// API status
  Status status = Status.completed;
  HtmlModel data = const HtmlModel(id: '', content: '');

  static TermsOfServicesController get instance =>
      Get.find<TermsOfServicesController>();

  final ApiClient apiClient = DioApiClient();

  /// Fetch terms of services
  Future<void> getTermsOfServices() async {
    return;
    try {
      status = Status.loading;
      update();
      final response = await apiClient.get(ApiEndPoint.termsOfServices);

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
    getTermsOfServices();
  }
}
