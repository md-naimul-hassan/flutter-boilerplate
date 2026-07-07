sealed class ForgotPasswordEvent {}

class ForgotSendEmailRequested extends ForgotPasswordEvent {
  final String email;

  ForgotSendEmailRequested(this.email);
}

class ForgotVerifyOtpRequested extends ForgotPasswordEvent {
  final String otp;

  ForgotVerifyOtpRequested(this.otp);
}

class ForgotResetPasswordRequested extends ForgotPasswordEvent {
  final String password;
  final String confirmPassword;

  ForgotResetPasswordRequested(this.password, this.confirmPassword);
}

class ForgotTimerStarted extends ForgotPasswordEvent {}

class ForgotTicked extends ForgotPasswordEvent {
  final int seconds;

  ForgotTicked(this.seconds);
}
