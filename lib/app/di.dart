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

/// Global service locator (replaces GetX dependency injection).
final GetIt sl = GetIt.instance;

/// Registers app-wide dependencies. Call once before `runApp`.
///
/// Only long-lived, dependency-graph objects live here (network client,
/// data sources, repositories, use cases). Blocs are created per-screen via
/// `BlocProvider` and pull what they need from here.
void dependencyInjection() {
  // Core
  sl.registerLazySingleton<ApiClient>(() => DioApiClient());

  // Sign In
  sl.registerLazySingleton(() => SignInRemoteDataSource(sl()));

  // Change Password
  sl.registerLazySingleton(() => ChangePasswordRemoteDataSource(sl()));

  // Forgot Password
  sl.registerLazySingleton(() => ForgotPasswordRemoteDataSource(sl()));

  // Sign Up
  sl.registerLazySingleton(() => SignUpRemoteDataSource(sl()));

  // Message
  sl.registerLazySingleton(() => MessageRemoteDataSource(sl()));

  // Notifications
  sl.registerLazySingleton(() => NotificationRemoteDataSource(sl()));

  // Profile
  sl.registerLazySingleton(() => ProfileRemoteDataSource(sl()));

  // Multi-screen flow blocs (shared state across their screens).
  sl.registerLazySingleton(() => SignUpBloc(sl()));
  sl.registerLazySingleton(() => ForgotPasswordBloc(sl()));
}
