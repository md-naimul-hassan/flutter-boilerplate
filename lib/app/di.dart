import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../features/auth/change_password/data/datasources/remote_data_source.dart';
import '../features/auth/forgot_password/data/datasources/remote_data_source.dart';
import '../features/auth/forgot_password/presentation/bloc/bloc.dart';
import '../features/auth/sign_up/data/datasources/remote_data_source.dart';
import '../features/auth/sign_up/presentation/bloc/bloc.dart';
import '../features/auth/sign_in/data/datasources/remote_data_source.dart';
import '../features/message/data/datasources/remote_data_source.dart';
import '../features/notifications/data/datasources/remote_data_source.dart';
import '../features/profile/data/datasources/remote_data_source.dart';
import '../features/setting/data/datasources/remote_data_source.dart';

final GetIt sl = GetIt.instance;

void dependencyInjection() {
  sl.registerLazySingleton<ApiClient>(() => DioApiClient());
  sl.registerLazySingleton(() => SignInRemoteDataSource(sl()));
  sl.registerLazySingleton(() => ChangePasswordRemoteDataSource(sl()));
  sl.registerLazySingleton(() => ForgotPasswordRemoteDataSource(sl()));
  sl.registerLazySingleton(() => SignUpRemoteDataSource(sl()));
  sl.registerLazySingleton(() => MessageRemoteDataSource(sl()));
  sl.registerLazySingleton(() => NotificationRemoteDataSource(sl()));
  sl.registerLazySingleton(() => ProfileRemoteDataSource(sl()));
  sl.registerLazySingleton(() => SettingRemoteDataSource(sl()));
  sl.registerFactory(() => SignUpBloc(sl()));
  sl.registerFactory(() => ForgotPasswordBloc(sl()));
}
