import '../../../../../app/enum.dart';

class ForgotPasswordState {
  final ApiStatus sendStatus;
  final ApiStatus verifyStatus;
  final ApiStatus resetStatus;
  final String email;
  final String forgetPasswordToken;
  final String message;
  final int seconds;

  const ForgotPasswordState({
    this.sendStatus = ApiStatus.initial,
    this.verifyStatus = ApiStatus.initial,
    this.resetStatus = ApiStatus.initial,
    this.email = '',
    this.forgetPasswordToken = '',
    this.message = '',
    this.seconds = 0,
  });

  bool get canResendOtp => seconds == 0;

  String get timerText {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  ForgotPasswordState copyWith({
    ApiStatus? sendStatus,
    ApiStatus? verifyStatus,
    ApiStatus? resetStatus,
    String? email,
    String? forgetPasswordToken,
    String? message,
    int? seconds,
  }) {
    return ForgotPasswordState(
      sendStatus: sendStatus ?? this.sendStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      resetStatus: resetStatus ?? this.resetStatus,
      email: email ?? this.email,
      forgetPasswordToken: forgetPasswordToken ?? this.forgetPasswordToken,
      message: message ?? this.message,
      seconds: seconds ?? this.seconds,
    );
  }
}
