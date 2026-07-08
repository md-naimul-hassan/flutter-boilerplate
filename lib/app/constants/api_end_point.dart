class ApiEndPoint {
  ApiEndPoint._();

  static const baseUrl = 'http://10.10.26.205:3000/api/';
  static const imageUrl = 'http://10.10.26.205:3000';
  static const socketUrl = 'http://10.10.26.205:3000';

  static const signUp = 'auth/register';
  static const verifyEmail = 'auth/verify-otp';
  static const resendOtp = 'auth/resend-otp';
  static const signIn = 'auth/login';
  static const forgotPassword = 'auth/forgot-password';
  static const verifyOtp = 'auth/verify-reset-otp';
  static const resetPassword = 'auth/reset-password';
  static const changePassword = 'auth/change-password';
  static const user = 'users';
  static const notifications = 'notifications';
  static const privacyPolicies = 'privacy-policies';
  static const termsOfServices = 'terms-and-conditions';
  static const chats = 'chats';
  static const messages = 'messages';
}
