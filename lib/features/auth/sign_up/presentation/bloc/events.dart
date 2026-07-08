sealed class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;

  SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignUpOtpSubmitted extends SignUpEvent {
  final String otp;

  SignUpOtpSubmitted(this.otp);
}

class SignUpResendRequested extends SignUpEvent {}

class SignUpTimerStarted extends SignUpEvent {}

class ResendOtpRequested extends SignUpEvent {
  final String email;

  ResendOtpRequested({required this.email});
}

class SignUpTicked extends SignUpEvent {
  final int seconds;

  SignUpTicked(this.seconds);
}
