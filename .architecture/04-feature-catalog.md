# Feature catalog

Paths are relative to `lib/features/`. Endpoints are relative to `ApiEndPoint.baseUrl`.

## auth/shared

Code reused by several auth sub-features.

- `data/models/auth_session_model.dart` — `AuthSessionModel { accessToken, refreshToken, UserModel user }`,
  parsed from the `data` object returned by login and verify-OTP.

## auth/sign_in

| Layer | Items |
| --- | --- |
| domain | `SignInRepository.signIn(email, password) → Result<void>`; use case `SignIn` |
| data | `SignInRemoteDataSource.signIn → AuthSessionModel` (`POST auth/login`); `SignInRepositoryImpl` saves token, refresh token and user to `LocalStorage` |
| presentation | `SignInBloc` (`SignInSubmitted`; connects `SocketService` on success); `SignInScreen` (`/sign-in-screen`) |

## auth/sign_up

| Layer | Items |
| --- | --- |
| domain | `SignUpRepository`: `signUp(name, email, password) → Result<String>` (sign-up token), `resendOtp(email) → Result<String>`, `verifyEmail(otp, signUpToken) → Result<void>`; use cases `SignUp`, `ResendSignUpOtp`, `VerifyEmail` |
| data | `POST auth/register`, `POST auth/resend-otp`, `POST auth/verify-otp` (header `SignUpToken: signUpToken <token>`); repository saves the session after verification |
| presentation | `SignUpBloc` — **flow bloc (lazy singleton)** with 180 s OTP timer; statuses `signUpStatus` / `resendStatus` / `verifyStatus`; `SignUpScreen` (`/sign-up-screen`), `VerifyUserScreen` (`/verify-user`) |

## auth/forgot_password

| Layer | Items |
| --- | --- |
| domain | `ForgotPasswordRepository`: `sendResetEmail(email) → Result<String>`, `verifyOtp(email, otp) → Result<String>` (reset token), `resetPassword(email, password, confirmPassword, token) → Result<String>`; use cases `SendResetEmail`, `VerifyResetOtp`, `ResetPassword` |
| data | `POST auth/forgot-password`, `POST auth/verify-reset-otp`, `POST auth/reset-password` (header `Forget-password: Forget-password <token>`) |
| presentation | `ForgotPasswordBloc` — **flow bloc (lazy singleton)** with 180 s OTP timer; statuses `sendStatus` / `resendStatus` / `verifyStatus` / `resetStatus` (resend via `ForgotResendOtpRequested`); `ForgotPasswordScreen` (`/forgot-password`), `VerifyScreen` (`/verify`), `CreatePasswordScreen` (`/create-password`) |

## auth/change_password

| Layer | Items |
| --- | --- |
| domain | `ChangePasswordRepository.changePassword(oldPassword, newPassword) → Result<String>`; use case `ChangePassword` |
| data | `PATCH auth/change-password` |
| presentation | `ChangePasswordBloc`; `ChangePasswordScreen` (`/change-password`) |

## message

| Layer | Items |
| --- | --- |
| domain | Entities `ChatEntity { id, ParticipantEntity participant, LatestMessageEntity latestMessage }`, `ChatMessageEntity { time, text, image, isMe, isCall, isNotice }`. `MessageRepository`: `getChats(page)`, `getMessages(chatId, page)`, `sendMessage(chatId, text)`, `listenChatListUpdates(onUpdate)`, `listenNewMessages(chatId, onMessage)`, `stopListenNewMessages(chatId)`. Use cases: `GetChats`, `GetMessages`, `SendMessage`, `ListenChatListUpdates`, `ListenNewMessages`, `StopListenNewMessages` |
| data | Models `ChatModel`/`ParticipantModel`/`LatestMessageModel` (extend entities), raw `MessageModel`/`SenderModel`. REST `GET chats?page=`, `GET messages?chatId=&page=&limit=15`. Socket: listen `update-chatlist::<userId>`, `new-message::<chatId>`; emit-with-ack `add-new-message`. Repository maps `MessageModel → ChatMessageEntity` (`isMe` = sender is the logged-in user, `isNotice` = `type == 'notice'`) |
| presentation | `ChatBloc` (list, pagination, live updates), `MessageBloc` (conversation, pagination, optimistic send, live messages); `ChatListScreen` (`/chat`), `MessageScreen` (`/message`, `extra: {chatId, name, image}`); widgets `ChatListItem`, `ChatBubbleMessage` |

Socket listeners are fire-and-forget callbacks (`void`), not `Result`s — `SocketService`
does not report errors back to the caller.

## notifications

| Layer | Items |
| --- | --- |
| domain | `NotificationEntity { id, message, linkId, type, role, receiver, createdAt, updatedAt }`; `NotificationRepository.getNotifications(page) → Result<List<NotificationEntity>>`; use case `GetNotifications` |
| data | `NotificationModel extends NotificationEntity`; `GET notifications?page=` |
| presentation | `NotificationsBloc` (start, load more, refresh; stops paginating on empty page); `NotificationScreen` (`/notifications`); widget `NotificationItem` |

## profile

| Layer | Items |
| --- | --- |
| domain | `ProfileRepository.updateProfile(fullName, phone, imagePath?) → Result<void>`; use case `UpdateProfile` |
| data | Multipart `POST users` (field `image` for the file); repository saves the returned user to `LocalStorage` |
| presentation | `ProfileBloc` (language selection, image pick, update); `ProfileScreen` (`/profile`), `EditProfileScreen` (`/edit-profile`); widget `EditProfileAllField` |

The logged-in user model is `core/models/user_model.dart` (`UserModel { id, name, email, image }`),
read anywhere via `LocalStorage.user`.

## setting

| Layer | Items |
| --- | --- |
| domain | `HtmlEntity { id, content }`; `SettingRepository`: `deleteAccount(password) → Result<void>`, `getPrivacyPolicy() → Result<HtmlEntity>`, `getTermsOfServices() → Result<HtmlEntity>`; use cases `DeleteAccount`, `GetPrivacyPolicy`, `GetTermsOfServices` |
| data | `HtmlModel extends HtmlEntity`; `DELETE users` (body `password`), `GET privacy-policies`, `GET terms-and-conditions` (content at `data.attributes`) |
| presentation | `SettingBloc` (delete account), `PrivacyPolicyBloc`, `TermsOfServicesBloc`; `SettingScreen` (`/setting-screen`, logs out after deletion), `PrivacyPolicyScreen` (`/privacy-policy`), `TermsOfServicesScreen` (`/terms-of-services`); widget `SettingItem` |

## splash / onboarding

Presentation only.

- `splash/presentation/screens/splash_screen.dart` (`/`) — waits 2 s, goes to `/profile` if
  `LocalStorage.isLogin`, otherwise `/onboarding`.
- `onboarding/presentation/screens/onboarding_screen.dart` (`/onboarding`) — sign-in / sign-up buttons.
