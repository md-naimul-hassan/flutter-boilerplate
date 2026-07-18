import 'package:get_it/get_it.dart';

import '../core/network/api_client.dart';
import '../core/network/api_service.dart';
import '../features/auth/change_password/data/datasources/change_password_remote_data_source.dart';
import '../features/auth/change_password/data/repositories/change_password_repository_impl.dart';
import '../features/auth/change_password/domain/repositories/change_password_repository.dart';
import '../features/auth/change_password/domain/usecases/change_password.dart';
import '../features/auth/change_password/presentation/bloc/change_password_bloc.dart';
import '../features/auth/forgot_password/data/datasources/forgot_password_remote_data_source.dart';
import '../features/auth/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import '../features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import '../features/auth/forgot_password/domain/usecases/reset_password.dart';
import '../features/auth/forgot_password/domain/usecases/send_reset_email.dart';
import '../features/auth/forgot_password/domain/usecases/verify_reset_otp.dart';
import '../features/auth/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import '../features/auth/sign_in/data/datasources/sign_in_remote_data_source.dart';
import '../features/auth/sign_in/data/repositories/sign_in_repository_impl.dart';
import '../features/auth/sign_in/domain/repositories/sign_in_repository.dart';
import '../features/auth/sign_in/domain/usecases/sign_in.dart';
import '../features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import '../features/auth/sign_up/data/datasources/sign_up_remote_data_source.dart';
import '../features/auth/sign_up/data/repositories/sign_up_repository_impl.dart';
import '../features/auth/sign_up/domain/repositories/sign_up_repository.dart';
import '../features/auth/sign_up/domain/usecases/resend_sign_up_otp.dart';
import '../features/auth/sign_up/domain/usecases/sign_up.dart';
import '../features/auth/sign_up/domain/usecases/verify_email.dart';
import '../features/auth/sign_up/presentation/bloc/sign_up_bloc.dart';
import '../features/message/data/datasources/message_remote_data_source.dart';
import '../features/message/data/repositories/message_repository_impl.dart';
import '../features/message/domain/repositories/message_repository.dart';
import '../features/message/domain/usecases/get_chats.dart';
import '../features/message/domain/usecases/get_messages.dart';
import '../features/message/domain/usecases/listen_chat_list_updates.dart';
import '../features/message/domain/usecases/listen_new_messages.dart';
import '../features/message/domain/usecases/send_message.dart';
import '../features/message/domain/usecases/stop_listen_new_messages.dart';
import '../features/message/presentation/bloc/chat_bloc.dart';
import '../features/message/presentation/bloc/message_bloc.dart';
import '../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../features/notifications/data/repositories/notification_repository_impl.dart';
import '../features/notifications/domain/repositories/notification_repository.dart';
import '../features/notifications/domain/usecases/get_notifications.dart';
import '../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../features/profile/data/datasources/profile_remote_data_source.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/update_profile.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/setting/data/datasources/setting_remote_data_source.dart';
import '../features/setting/data/repositories/setting_repository_impl.dart';
import '../features/setting/domain/repositories/setting_repository.dart';
import '../features/setting/domain/usecases/delete_account.dart';
import '../features/setting/domain/usecases/get_privacy_policy.dart';
import '../features/setting/domain/usecases/get_terms_of_services.dart';
import '../features/setting/presentation/bloc/privacy_policy_bloc.dart';
import '../features/setting/presentation/bloc/setting_bloc.dart';
import '../features/setting/presentation/bloc/terms_of_services_bloc.dart';

final GetIt sl = GetIt.instance;

void dependencyInjection() {
  sl.registerLazySingleton<ApiClient>(() => DioApiClient());

  _signIn();
  _signUp();
  _forgotPassword();
  _changePassword();
  _message();
  _notifications();
  _profile();
  _setting();
}

void _signIn() {
  sl
    ..registerLazySingleton<SignInRemoteDataSource>(
      () => SignInRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SignInRepository>(() => SignInRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerFactory(() => SignInBloc(signIn: sl()));
}

/// [SignUpBloc] is shared by every screen of the sign-up flow, so it is a singleton.
void _signUp() {
  sl
    ..registerLazySingleton<SignUpRemoteDataSource>(
      () => SignUpRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SignUpRepository>(() => SignUpRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ResendSignUpOtp(sl()))
    ..registerLazySingleton(() => VerifyEmail(sl()))
    ..registerLazySingleton(
      () => SignUpBloc(signUp: sl(), resendOtp: sl(), verifyEmail: sl()),
    );
}

/// [ForgotPasswordBloc] is shared by every screen of the reset flow, so it is a singleton.
void _forgotPassword() {
  sl
    ..registerLazySingleton<ForgotPasswordRemoteDataSource>(
      () => ForgotPasswordRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ForgotPasswordRepository>(
      () => ForgotPasswordRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => SendResetEmail(sl()))
    ..registerLazySingleton(() => VerifyResetOtp(sl()))
    ..registerLazySingleton(() => ResetPassword(sl()))
    ..registerLazySingleton(
      () => ForgotPasswordBloc(
        sendResetEmail: sl(),
        verifyResetOtp: sl(),
        resetPassword: sl(),
      ),
    );
}

void _changePassword() {
  sl
    ..registerLazySingleton<ChangePasswordRemoteDataSource>(
      () => ChangePasswordRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ChangePasswordRepository>(
      () => ChangePasswordRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => ChangePassword(sl()))
    ..registerFactory(() => ChangePasswordBloc(changePassword: sl()));
}

void _message() {
  sl
    ..registerLazySingleton<MessageRemoteDataSource>(
      () => MessageRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetChats(sl()))
    ..registerLazySingleton(() => GetMessages(sl()))
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton(() => ListenChatListUpdates(sl()))
    ..registerLazySingleton(() => ListenNewMessages(sl()))
    ..registerLazySingleton(() => StopListenNewMessages(sl()))
    ..registerFactory(
      () => ChatBloc(getChats: sl(), listenChatListUpdates: sl()),
    )
    ..registerFactory(
      () => MessageBloc(
        getMessages: sl(),
        sendMessage: sl(),
        listenNewMessages: sl(),
        stopListenNewMessages: sl(),
      ),
    );
}

void _notifications() {
  sl
    ..registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetNotifications(sl()))
    ..registerFactory(() => NotificationsBloc(getNotifications: sl()));
}

void _profile() {
  sl
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => UpdateProfile(sl()))
    ..registerFactory(() => ProfileBloc(updateProfile: sl()));
}

void _setting() {
  sl
    ..registerLazySingleton<SettingRemoteDataSource>(
      () => SettingRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SettingRepository>(
      () => SettingRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => DeleteAccount(sl()))
    ..registerLazySingleton(() => GetPrivacyPolicy(sl()))
    ..registerLazySingleton(() => GetTermsOfServices(sl()))
    ..registerFactory(() => SettingBloc(deleteAccount: sl()))
    ..registerFactory(() => PrivacyPolicyBloc(getPrivacyPolicy: sl()))
    ..registerFactory(() => TermsOfServicesBloc(getTermsOfServices: sl()));
}
