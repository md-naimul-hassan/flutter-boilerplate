# Boilerplate audit (before migration)

Snapshot taken at commit `1b6653b` ("fix issue"). `fvm flutter analyze` (Flutter 3.44.1)
reported 2 pre-existing issues, both unrelated to architecture:

- `lib/core/component/image/common_image.dart:74` — deprecated `color` on `SvgPicture`.
- `pubspec.yaml` — asset directory `assets/icons/` does not exist.

## App shell

| File | Role |
| --- | --- |
| `lib/main.dart` | `runZonedGuarded`, portrait lock, `LocalStorage.init()`, `dependencyInjection()`, delayed `SocketService.connect()` |
| `lib/app/app.dart` | `ScreenUtilInit(428×926)` → `MaterialApp.router(appRouter)` with `scaffoldMessengerKey` |
| `lib/app/router.dart` | `AppRoutes` constants, `GoRouter appRouter`, `AppNavigator` static helpers |
| `lib/app/di.dart` | `GetIt sl`; registered `ApiClient`, 8 remote data sources, `SignUpBloc`/`ForgotPasswordBloc` as **factories** |
| `lib/app/enum.dart` | `ApiStatus`, `ForgetPasswordStep` |
| `lib/app/constants/` | `ApiEndPoint`, `AppColors`, `AppIcons`, `AppImages`, `AppString` |

## Core

| Folder | Contents |
| --- | --- |
| `core/network/` | `ApiClient` (abstract), `DioApiClient` (in `api_service.dart`), `DioConfig`, `AuthInterceptor` (Bearer token from `LocalStorage`), `ApiResponseHandler` (maps Dio errors to status codes: timeout→408, connection→503, bad response→real code), `ApiResponseModel` (`isSuccess`, `statusCode`, `message`, `data`), `MultipartHelper` |
| `core/error/` | `exceptions.dart` (`_AppException` base + `ApiException`, `InternetException`, `RequestTimeoutException`, `ServerException`, `UnauthorizedException`, …), `error_handler.dart` (`globalError`), **`failures.dart` empty** |
| `core/storage/` | `LocalStorage` static wrapper (token, refreshToken, `UserModel user`, `logout()`), `LocalStorageKeys` |
| `core/services/socket/` | `SocketService` static wrapper (`connect`, `on`, `off`, `emit`, `emitWithAck`, user-notification listener) |
| `core/component/` | Shared widgets (`CommonText`, `CommonButton`, `CommonTextField`, `CommonImage`, loaders, error/no-internet screens, bottom bar, pop menu) |
| `core/utils/` | `AppSnackbar`, logger, extensions, validation, `OtherHelper.pickImage` |

## Features (before)

Every feature had only `data/` + `presentation/`:

| Feature | Data source methods | Blocs | Screens |
| --- | --- | --- | --- |
| `auth/sign_in` | `signIn` (saves tokens + user to `LocalStorage`) | `SignInBloc` | `SignInScreen` |
| `auth/sign_up` | `signUp`, `resendOtp`, `verifyEmail` (saves session) | `SignUpBloc` (flow, OTP timer) | `SignUpScreen`, `VerifyUser` |
| `auth/forgot_password` | `sendResetEmail`, `verifyOtp`, `resetPassword` | `ForgotPasswordBloc` (flow, OTP timer) | `ForgotPasswordScreen`, `VerifyScreen`, `CreatePassword` |
| `auth/change_password` | `changePassword` | `ChangePasswordBloc` | `ChangePasswordScreen` |
| `message` | `fetchChats`, `fetchMessages`, `sendMessage` (socket), `listenChatListUpdates`, `listenNewMessages`, `stopListenNewMessages` | `ChatBloc`, `MessageBloc` | `ChatListScreen`, `MessageScreen` |
| `notifications` | `fetchNotifications` | `NotificationsBloc` | `NotificationScreen` |
| `profile` | `updateProfile` (multipart, saves user) | `ProfileBloc` | `ProfileScreen`, `EditProfile` |
| `setting` | `deleteAccount`, `fetchPrivacyPolicy`, `fetchTermsOfServices` | `SettingBloc`, `PrivacyPolicyBloc`, `TermsOfServicesBloc` (event/state/bloc in one file) | `SettingScreen`, `PrivacyPolicyScreen`, `TermsOfServicesScreen` |
| `splash` | – | – | `splash_screen.dart` at feature root |
| `onboarding` | – | – | `onboarding_screen.dart` at feature root |

## Problems found

### Architecture

1. **No domain layer.** Blocs depended directly on concrete `*RemoteDataSource` classes;
   there were no entities, repository contracts or use cases.
2. **Data models leaked into presentation.** Screens, widgets, states and events imported
   `data/models/*`.
3. **Core depended on a feature.** `core/storage/storage_services.dart` imported
   `features/profile/data/models/user_model.dart` — the dependency arrow pointed the wrong way.
4. **Persistence inside remote data sources.** `SignIn`/`SignUp`/`Profile` remote data
   sources wrote to `LocalStorage`.
5. **Error handling duplicated in every bloc** (`on ApiException catch … catch (e) …`),
   and some blocs (`ProfileBloc`, `SettingBloc`) showed `e.toString()` — i.e.
   `"Exception: 400 => message"` — to the user. `failures.dart` was empty.
6. **Blocs constructed by hand in screens** (`SignInBloc(sl<SignInRemoteDataSource>())`),
   so the screen knew the bloc's dependencies.
7. **Inconsistent naming**: `bloc.dart`/`events.dart`/`state.dart`, `screen/` vs `screens/`,
   `widget/` vs `widgets/`, `change_password/presentation/screen/screen.dart`,
   generic `remote_data_source.dart` in every feature.

### Bugs

1. **Flow blocs lost their state between screens.** `SignUpBloc` and `ForgotPasswordBloc`
   were registered with `registerFactory`, yet every screen of the flow did
   `BlocProvider.value(value: sl<SignUpBloc>())` inside `build()`. Each call created a
   *new* bloc, so `VerifyUser` never saw the `signUpToken`/`email` stored by
   `SignUpScreen`, `VerifyScreen` never saw the email, and `CreatePassword` never saw the
   reset token. A rebuild of the same screen also swapped in a fresh bloc.
2. `test/widget_test.dart` is still the Flutter counter template and does not match the app
   (pre-existing, out of scope for this migration).
