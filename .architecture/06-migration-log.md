# Migration log — clean architecture per feature

Base commit: `1b6653b`. Reference: [md-naimul-hassan/todo-app](https://github.com/md-naimul-hassan/todo-app).

## Verification

- `fvm flutter analyze` — same 2 pre-existing issues as before the migration
  (`common_image.dart` deprecated `color`, missing `assets/icons/`), no new ones.
- `fvm flutter test test/app test/core` — 7 tests pass:
  - `test/app/di_test.dart` resolves every bloc from `get_it`, asserts flow blocs are
    singletons and screen blocs are factories.
  - `test/core/error/failures_test.dart` covers the `catchFailure` mapping.
- Layer audit (ripgrep): no `presentation → data` imports, no Flutter/Dio/storage imports
  in `domain`, no `core → features` imports.

## What changed

### Dependencies

- Added `equatable: ^3.0.0` (entities, failures, events, states).

### Core

- `core/error/exceptions.dart` — base class `_AppException` made public as `AppException`
  so failures can pattern-match on it.
- `core/error/failures.dart` — was empty; now `Failure` + `ServerFailure`,
  `NetworkFailure`, `UnauthorizedFailure`, `UnknownFailure` and `catchFailure()`.
- `core/error/result.dart` — new sealed `Result<T>` (`Success` / `Failed`).
- `core/models/user_model.dart` — moved from `features/profile/data/models/` so
  `LocalStorage` no longer imports a feature.

### Features

Every feature with API calls now has `domain/` (repository contract + use cases,
entities where data is returned) and `data/repositories/*_repository_impl.dart`.
Data sources became abstract + `Impl`. Blocs depend on use cases and are built by DI.
See [04-feature-catalog.md](04-feature-catalog.md) for the full per-feature list.

Renames (all with `git mv`, so history is preserved):

| Before | After |
| --- | --- |
| `*/data/datasources/remote_data_source.dart` | `*/data/datasources/<feature>_remote_data_source.dart` |
| `presentation/bloc/{bloc,events,state}.dart` | `presentation/bloc/<name>_{bloc,event,state}.dart` (`part` files) |
| `presentation/screen/`, `presentation/widget/` | `presentation/screens/`, `presentation/widgets/` |
| `change_password/.../screen/screen.dart` | `change_password/.../screens/change_password_screen.dart` |
| `forgot_password/.../create_password.dart`, `forgot_password.dart` | `create_password_screen.dart`, `forgot_password_screen.dart` |
| `sign_up/.../verify_user.dart` | `verify_user_screen.dart` |
| `profile/.../edit_profile.dart` | `edit_profile_screen.dart` |
| `message/.../chat_screen.dart` | `chat_list_screen.dart` |
| `message/data/models/chat_list_model.dart` | `chat_model.dart` (+ `domain/entities/chat_entity.dart`) |
| `message/data/models/chat_message_model.dart` | `domain/entities/chat_message_entity.dart` |
| `message/presentation/bloc/{chat,message}/…` | flat `chat_bloc.dart`, `message_bloc.dart` + parts |
| `setting/presentation/bloc/*_bloc.dart` (event/state inline) | bloc + `part` event/state files |
| `splash/splash_screen.dart`, `onboarding/onboarding_screen.dart` | `<feature>/presentation/screens/…` |

Class renames: `VerifyUser` → `VerifyUserScreen`, `CreatePassword` → `CreatePasswordScreen`,
`EditProfile` → `EditProfileScreen`, `Sender` → `SenderModel`. Unused event
`SignUpResendRequested` removed.

### App shell

- `app/di.dart` — registers data source → repository → use cases → bloc per feature.
- `app/router.dart` — imports and screen class names updated; routes unchanged.

## Behaviour changes (intentional)

1. **Flow blocs fixed.** `SignUpBloc` and `ForgotPasswordBloc` are now
   `registerLazySingleton`. Previously every `sl<…>()` call created a new bloc, so the
   OTP / reset screens never received the email or token from the previous step.
2. **Resend OTP no longer re-triggers the previous screen.** Because the flow bloc is now
   shared, resending would flip `signUpStatus` / `sendStatus`, which the still-mounted
   first screen listens to (it would push a second verify screen). Resend now uses a
   separate `resendStatus` field and event (`ResendOtpRequested`,
   `ForgotResendOtpRequested`), handled by its own `BlocListener` on the verify screen.
3. **User-facing error messages.** Blocs show `failure.message` (the server's message)
   instead of `e.toString()`, which used to render as `"Exception: 400 => …"` in
   `ProfileBloc` and `SettingBloc`. Unexpected non-API errors show
   `AppString.unknownError` and are logged with `logError`.
4. **Equatable states.** Emitting a state equal to the current one is now a no-op.
   `SettingBloc` emits `loading` before validating the password so a repeated empty
   submit still shows the error.
5. **Persistence moved to repositories.** Saving tokens/user to `LocalStorage` happens in
   `SignInRepositoryImpl`, `SignUpRepositoryImpl.verifyEmail` and
   `ProfileRepositoryImpl` instead of inside remote data sources. Stored data is identical.

## SDK upgrade (Flutter 3.47.7 / Dart 3.13.5 via FVM)

- `.fvmrc` pins Flutter `3.47.7`; `.vscode/settings.json` points `dart.flutterSdkPath` at
  `.fvm/versions/3.47.7`. Run everything through `fvm flutter …` / `fvm dart …`.
- `pubspec.yaml` SDK constraint `^3.10.4` → `^3.13.5`; CI workflows `3.38.5` → `3.47.7`.
- Dependencies upgraded within existing constraints (`flutter pub upgrade`).
- `dependency_overrides: html: 0.15.6` — newer `html` removed the `matches` API that
  `flutter_html` 3.0.0 (latest) calls, which breaks compilation. Drop the override when
  `flutter_html` ships a fix.
- All bloc constructors use Dart 3.12+ private named params (`required this._signIn`)
  instead of initializer lists; `prefer_initializing_formals` flags the old style on 3.13.
  DI call sites are unchanged (`SignInBloc(signIn: sl())`).
- Not done: major-version bumps (`go_router` 18, `google_fonts` 9, `pin_code_fields` 10,
  `cached_network_image` 4, `cupertino_icons` 2) — they need API review.

## Known follow-ups (not done)

- Flow blocs keep their state for the app lifetime; starting the flow a second time
  starts from the previous values (statuses still transition, so listeners fire). A
  cleaner option is scoping them with a go_router `ShellRoute`.
- `test/widget_test.dart` is still the Flutter counter template and fails against this app.
- Socket listeners are callbacks; converting them to `Stream`s would let blocs use
  `emit.forEach` and cancel subscriptions automatically.
- Pre-existing analyzer issues: deprecated `color` in `CommonImage`, missing `assets/icons/`.
