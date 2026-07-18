import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/change_password/presentation/screen/screen.dart';
import '../features/auth/forgot_password/presentation/screen/create_password.dart';
import '../features/auth/forgot_password/presentation/screen/forgot_password.dart';
import '../features/auth/forgot_password/presentation/screen/verify_screen.dart';
import '../../features/auth/sign_in/presentation/screen/sign_in_screen.dart';
import '../features/auth/sign_up/presentation/screen/sign_up_screen.dart';
import '../features/auth/sign_up/presentation/screen/verify_user.dart';
import '../../features/message/presentation/screen/chat_screen.dart';
import '../../features/message/presentation/screen/message_screen.dart';
import '../../features/notifications/presentation/screen/notifications_screen.dart';
import '../../features/profile/presentation/screen/edit_profile.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import '../../features/setting/presentation/screen/privacy_policy_screen.dart';
import '../../features/setting/presentation/screen/setting_screen.dart';
import '../../features/setting/presentation/screen/terms_of_services_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signUp = '/sign-up-screen';
  static const String verifyUser = '/verify-user';
  static const String signIn = '/sign-in-screen';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify';
  static const String createPassword = '/create-password';
  static const String changePassword = '/change-password';
  static const String notifications = '/notifications';
  static const String chat = '/chat';
  static const String message = '/message';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfServices = '/terms-of-services';
  static const String setting = '/setting-screen';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) => const OnboardingScreen(),
    ),
    GoRoute(path: AppRoutes.signUp, builder: (_, _) => const SignUpScreen()),
    GoRoute(path: AppRoutes.verifyUser, builder: (_, _) => const VerifyUser()),
    GoRoute(path: AppRoutes.signIn, builder: (_, _) => const SignInScreen()),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, _) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      builder: (_, _) => const VerifyScreen(),
    ),
    GoRoute(
      path: AppRoutes.createPassword,
      builder: (_, _) => const CreatePassword(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      builder: (_, _) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (_, _) => const NotificationScreen(),
    ),
    GoRoute(path: AppRoutes.chat, builder: (_, _) => const ChatListScreen()),
    GoRoute(
      path: AppRoutes.message,
      builder: (_, state) {
        final args = (state.extra as Map?)?.cast<String, String>() ?? const {};
        return MessageScreen(
          chatId: args['chatId'] ?? '',
          name: args['name'] ?? '',
          image: args['image'] ?? '',
        );
      },
    ),
    GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (_, _) => const EditProfile(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (_, _) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.termsOfServices,
      builder: (_, _) => const TermsOfServicesScreen(),
    ),
    GoRoute(path: AppRoutes.setting, builder: (_, _) => const SettingScreen()),
  ],
);

class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T>(String location, {Object? extra}) {
    return appRouter.push<T>(location, extra: extra);
  }

  static void go(String location, {Object? extra}) {
    appRouter.go(location, extra: extra);
  }

  static void pushReplacement(String location, {Object? extra}) {
    appRouter.pushReplacement(location, extra: extra);
  }

  static void pop<T>([T? result]) {
    if (appRouter.canPop()) appRouter.pop<T>(result);
  }
}
