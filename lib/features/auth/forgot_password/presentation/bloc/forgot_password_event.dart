part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotSendEmailRequested extends ForgotPasswordEvent {
  const ForgotSendEmailRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class ForgotResendOtpRequested extends ForgotPasswordEvent {
  const ForgotResendOtpRequested();
}

class ForgotVerifyOtpRequested extends ForgotPasswordEvent {
  const ForgotVerifyOtpRequested(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

class ForgotResetPasswordRequested extends ForgotPasswordEvent {
  const ForgotResetPasswordRequested(this.password, this.confirmPassword);

  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [password, confirmPassword];
}

class ForgotTimerStarted extends ForgotPasswordEvent {
  const ForgotTimerStarted();
}

class ForgotTicked extends ForgotPasswordEvent {
  const ForgotTicked(this.seconds);

  final int seconds;

  @override
  List<Object?> get props => [seconds];
}
