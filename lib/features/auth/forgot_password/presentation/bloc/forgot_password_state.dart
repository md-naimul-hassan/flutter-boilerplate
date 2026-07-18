part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.sendStatus = ApiStatus.initial,
    this.resendStatus = ApiStatus.initial,
    this.verifyStatus = ApiStatus.initial,
    this.resetStatus = ApiStatus.initial,
    this.email = '',
    this.forgetPasswordToken = '',
    this.message = '',
    this.seconds = 0,
  });

  final ApiStatus sendStatus;
  final ApiStatus resendStatus;
  final ApiStatus verifyStatus;
  final ApiStatus resetStatus;
  final String email;
  final String forgetPasswordToken;
  final String message;
  final int seconds;

  bool get canResendOtp => seconds == 0;

  String get timerText {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  ForgotPasswordState copyWith({
    ApiStatus? sendStatus,
    ApiStatus? resendStatus,
    ApiStatus? verifyStatus,
    ApiStatus? resetStatus,
    String? email,
    String? forgetPasswordToken,
    String? message,
    int? seconds,
  }) {
    return ForgotPasswordState(
      sendStatus: sendStatus ?? this.sendStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      resetStatus: resetStatus ?? this.resetStatus,
      email: email ?? this.email,
      forgetPasswordToken: forgetPasswordToken ?? this.forgetPasswordToken,
      message: message ?? this.message,
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  List<Object?> get props => [
    sendStatus,
    resendStatus,
    verifyStatus,
    resetStatus,
    email,
    forgetPasswordToken,
    message,
    seconds,
  ];
}
