# Flutter Boilerplate

A feature-first Flutter starter for mobile apps with authentication, messaging, notifications, and profile management. The project uses BLoC for state management, `go_router` for navigation, and Dio for REST API communication with Socket.IO for real-time chat.

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Project](#running-the-project)
- [Available Commands](#available-commands)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Build & Deployment](#build--deployment)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Features

- **Authentication** — Sign up, email OTP verification, sign in, forgot password, reset password, and change password flows
- **Onboarding & Splash** — Intro screens and an initial splash route
- **Messaging** — Chat list and conversation screens with REST pagination and Socket.IO real-time updates
- **Notifications** — Paginated notification list
- **Profile** — View and edit profile, including optional image upload
- **Settings** — Account deletion, privacy policy, and terms of service (HTML content)
- **State management** — `flutter_bloc` with per-screen blocs and shared flow blocs registered in GetIt
- **Networking** — Dio client with bearer token auth, cookie management, and debug request logging
- **Local storage** — Token, refresh token, and user data persisted via SharedPreferences
- **Responsive UI** — `flutter_screenutil` with a 428×926 design size, shared components, and Material 3 theme
- **Error handling** — Global zone guard, centralized API error mapping, and dedicated error/no-internet screens

## Tech Stack

| Category | Packages |
| --- | --- |
| Language / SDK | Dart `^3.10.4`, Flutter |
| State management | `flutter_bloc` |
| Navigation | `go_router` |
| Dependency injection | `get_it` |
| Networking | `dio`, `dio_cookie_manager`, `cookie_jar`, `pretty_dio_logger` |
| Real-time | `socket_io_client` |
| UI | `flutter_screenutil`, `google_fonts`, `flutter_svg`, `cached_network_image`, `flutter_html` |
| Forms & input | `intl_phone_field`, `pin_code_fields`, `image_picker` |
| Storage | `shared_preferences` |
| Utilities | `intl`, `mime`, `logger` |
| Linting | `flutter_lints` |

**Supported platforms:** Android, iOS, and Web (project metadata also includes desktop targets).

## Project Structure

```text
flutter-boilerplate/
├── android/                  # Android native project
├── assets/
│   ├── icons/
│   └── images/
├── ios/                      # iOS native project
├── lib/
│   ├── app/                  # App shell: theme, router, DI, constants
│   │   └── constants/        # API endpoints, colors, images, strings
│   ├── core/
│   │   ├── component/        # Reusable UI (buttons, fields, loaders, bottom nav)
│   │   ├── error/            # Exceptions, failures, global error handler
│   │   ├── network/          # Dio client, interceptors, API response handling
│   │   ├── secret_key/       # Placeholder keys for future integrations
│   │   ├── services/socket/ # Socket.IO service
│   │   ├── storage/          # SharedPreferences wrapper (LocalStorage)
│   │   └── utils/            # Extensions, helpers, logging, snackbars
│   ├── features/
│   │   ├── auth/             # sign_in, sign_up, forgot_password, change_password
│   │   ├── message/          # Chat list and messaging
│   │   ├── notifications/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   ├── setting/
│   │   └── splash/
│   └── main.dart             # Entry point
├── test/                     # Widget tests
└── web/                      # Web entry point
```

Each feature module typically follows a `data/` (remote data sources, models) and `presentation/` (screens, blocs, widgets) layout.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible with Dart `^3.10.4`
- [FVM](https://fvm.app/) (recommended) — this project pins Flutter `3.44.1` in `.fvmrc`
- Xcode (for iOS builds on macOS)
- Android Studio / Android SDK (for Android builds)
- A running backend API and Socket.IO server (see [Configuration](#configuration))

### Flutter Version Management (FVM)

This project uses FVM to pin the Flutter SDK version across developers and environments.

**Pinned version:** `3.44.1` (`.fvmrc`)

```bash
# Install FVM: https://fvm.app/documentation/getting-started/installation
fvm install
fvm use
fvm flutter pub get
```

Use `fvm flutter` in place of `flutter` for all commands when FVM is enabled.

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/md-naimul-hassan/flutter-boilerplate.git
   cd flutter-boilerplate
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

   With FVM:

   ```bash
   fvm flutter pub get
   ```

3. **Configure the backend URL** — Update `lib/app/constants/api_end_point.dart` with your API and socket server addresses (see [Configuration](#configuration)).

4. **Run the app**

   ```bash
   flutter run
   ```

## Configuration

This project does not use a `.env` file. Backend and integration settings are defined in source code.

### API & Socket URLs

Edit `lib/app/constants/api_end_point.dart`:

```dart
static const baseUrl = 'http://YOUR_HOST:PORT/api/';
static const imageUrl = 'http://YOUR_HOST:PORT';
static const socketUrl = 'http://YOUR_HOST:PORT';
```

All REST paths are relative to `baseUrl`. The Dio client applies a 30-second connect/receive/send timeout and attaches a `Bearer` token from local storage on every request.

### Secret keys (optional)

`lib/core/secret_key/secret_key.dart` contains empty placeholders (`publishableKey`, `secretKey`, `paymentIntent`) for future payment or third-party integrations. These values are not used by the current codebase.

### Android notes

- Cleartext HTTP traffic is enabled (`android:usesCleartextTraffic="true"`) for local/non-HTTPS development.
- Camera and media read permissions are declared for image picker usage.

## Running the Project

### Development

```bash
# List connected devices
flutter devices

# Run on a specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

The app initializes in portrait orientation, loads persisted auth data, and connects to Socket.IO shortly after startup.

### Production builds

**Android APK**

```bash
flutter build apk --release
```

**Android App Bundle (Play Store)**

```bash
flutter build appbundle --release
```

**iOS**

```bash
flutter build ios --release
```

**iOS IPA (App Store / TestFlight)**

```bash
flutter build ipa --release
```

## Available Commands

This project has no custom npm/Makefile scripts. Use standard Flutter tooling:

| Command | Description |
| --- | --- |
| `flutter pub get` | Install dependencies |
| `flutter pub upgrade` | Upgrade dependencies |
| `flutter analyze` | Run static analysis (`analysis_options.yaml`) |
| `flutter test` | Run tests in `test/` |
| `flutter run` | Run the app in debug mode |
| `flutter build apk --release` | Build Android APK |
| `flutter build appbundle --release` | Build Android App Bundle |
| `flutter build ios --release` | Build iOS release |
| `flutter build ipa --release` | Build iOS IPA |

Prefix commands with `fvm` when using FVM (e.g. `fvm flutter analyze`).

## API Endpoints

Base URL is configured in `ApiEndPoint.baseUrl`. The following REST paths are used:

| Method | Path | Feature |
| --- | --- | --- |
| `POST` | `auth/register` | Sign up |
| `POST` | `auth/verify-otp` | Verify registration OTP |
| `POST` | `auth/resend-otp` | Resend registration OTP |
| `POST` | `auth/login` | Sign in |
| `POST` | `auth/forgot-password` | Request password reset |
| `POST` | `auth/verify-reset-otp` | Verify reset OTP |
| `POST` | `auth/reset-password` | Reset password |
| `PATCH` | `auth/change-password` | Change password |
| `GET` | `users` | Profile (multipart update via `PATCH`-style multipart) |
| `DELETE` | `users` | Delete account |
| `GET` | `notifications?page={page}` | List notifications |
| `GET` | `privacy-policies` | Privacy policy HTML |
| `GET` | `terms-and-conditions` | Terms of service HTML |
| `GET` | `chats?page={page}` | Chat list |
| `GET` | `messages?chatId={id}&page={page}&limit=15` | Chat messages |

### Socket.IO events

| Event | Direction | Purpose |
| --- | --- | --- |
| `user-notification::{userId}` | Listen | User-specific notifications |
| `update-chatlist::{userId}` | Listen | Chat list updates |
| `new-message::{chatId}` | Listen | Incoming messages in a chat |
| `add-new-message` | Emit (with ack) | Send a new message |

### App routes

Routes are defined in `lib/app/router.dart` (`AppRoutes`):

`/`, `/onboarding`, `/sign-up-screen`, `/verify-user`, `/sign-in-screen`, `/forgot-password`, `/verify`, `/create-password`, `/change-password`, `/notifications`, `/chat`, `/message`, `/profile`, `/edit-profile`, `/privacy-policy`, `/terms-of-services`, `/setting-screen`

## Testing

Tests live in `test/`. Run them with:

```bash
flutter test
```

The project uses `flutter_test` and `flutter_lints` for analysis. Update or replace the default widget test in `test/widget_test.dart` to match the current app entry point (`MyApp`).

## Build & Deployment

GitHub Actions workflows in `.github/workflows/` deploy on pushes to the `production` branch:

| Workflow | Platform | Output |
| --- | --- | --- |
| `flutter-play-store.yml` | Android | AAB uploaded to Google Play (internal track) |
| `flutter-app-store.yml` | iOS | IPA uploaded to TestFlight |

### CI secrets

**Android (`flutter-play-store.yml`)**

- `KEYSTORE_BASE64`
- `STORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`
- `PLAY_STORE_JSON`

**iOS (`flutter-app-store.yml`)**

- `IOS_P12_BASE64`
- `IOS_P12_PASSWORD`
- `IOS_PROVISION_PROFILE`
- `APP_STORE_KEY_ID`
- `APP_STORE_ISSUER_ID`
- `APP_STORE_PRIVATE_KEY`

> **Note:** CI workflows reference Flutter `3.38.5`, while `.fvmrc` pins `3.44.1`. Align these versions for consistent local and CI builds.

## Troubleshooting

| Issue | Suggestion |
| --- | --- |
| API requests fail on Android emulator/device | Confirm `baseUrl` in `api_end_point.dart` is reachable from the device. Use your machine's LAN IP instead of `localhost` when testing against a local server. |
| Socket does not connect | Verify `socketUrl` matches your backend and that the user is logged in (user ID is required for notification listeners). |
| HTTP blocked on Android | Cleartext traffic is enabled for development; use HTTPS in production or update network security config. |
| FVM / Flutter version mismatch | Run `fvm install && fvm use` and ensure CI Flutter version matches `.fvmrc`. |
| `flutter pub get` errors | Confirm Dart SDK `^3.10.4` and run `flutter doctor` to verify your environment. |

## Contributing

Contributions are welcome. Please open a pull request with a clear description of your changes.

Ensure code passes analysis before submitting:

```bash
flutter analyze
flutter test
```
