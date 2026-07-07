import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../data/datasources/remote_data_source.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChangePasswordRemoteDataSource(Get.find<ApiClient>()),
      fenix: true,
    );
  }
}
