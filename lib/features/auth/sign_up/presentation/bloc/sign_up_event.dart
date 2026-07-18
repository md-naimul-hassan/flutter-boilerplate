part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

class SignUpOtpSubmitted extends SignUpEvent {
  const SignUpOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object?> get props => [otp];
}

class SignUpTimerStarted extends SignUpEvent {
  const SignUpTimerStarted();
}

class ResendOtpRequested extends SignUpEvent {
  const ResendOtpRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignUpTicked extends SignUpEvent {
  const SignUpTicked(this.seconds);

  final int seconds;

  @override
  List<Object?> get props => [seconds];
}
