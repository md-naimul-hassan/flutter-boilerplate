import '../../../../../app/enum.dart';

class SignUpState {
  final ApiStatus signUpStatus;
  final ApiStatus verifyStatus;
  final String email;
  final String signUpToken;
  final String message;
  final int seconds;

  const SignUpState({
    this.signUpStatus = ApiStatus.initial,
    this.verifyStatus = ApiStatus.initial,
    this.email = '',
    this.signUpToken = '',
    this.message = '',
    this.seconds = 0,
  });

  String get time {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  SignUpState copyWith({
    ApiStatus? signUpStatus,
    ApiStatus? verifyStatus,
    String? email,
    String? signUpToken,
    String? message,
    int? seconds,
  }) {
    return SignUpState(
      signUpStatus: signUpStatus ?? this.signUpStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      email: email ?? this.email,
      signUpToken: signUpToken ?? this.signUpToken,
      message: message ?? this.message,
      seconds: seconds ?? this.seconds,
    );
  }
}
