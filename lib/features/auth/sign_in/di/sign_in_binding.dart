import 'package:get/get.dart';
import '../../../../core/services/api/api_client.dart';
import '../data/datasources/sign_in_remote_data_source.dart';
import '../data/repositories/sign_in_repository_impl.dart';
import '../domain/repositories/sign_in_repository.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../presentation/controller/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInRemoteDataSource>(
      () => SignInRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SignInRepository>(
      () => SignInRepositoryImpl(Get.find<SignInRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SignInUseCase(Get.find<SignInRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SignInController(Get.find<SignInUseCase>()),
      fenix: true,
    );
  }
}
