part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.signUpStatus = ApiStatus.initial,
    this.resendStatus = ApiStatus.initial,
    this.verifyStatus = ApiStatus.initial,
    this.email = '',
    this.signUpToken = '',
    this.message = '',
    this.seconds = 0,
  });

  final ApiStatus signUpStatus;
  final ApiStatus resendStatus;
  final ApiStatus verifyStatus;
  final String email;
  final String signUpToken;
  final String message;
  final int seconds;

  String get time {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  SignUpState copyWith({
    ApiStatus? signUpStatus,
    ApiStatus? resendStatus,
    ApiStatus? verifyStatus,
    String? email,
    String? signUpToken,
    String? message,
    int? seconds,
  }) {
    return SignUpState(
      signUpStatus: signUpStatus ?? this.signUpStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      email: email ?? this.email,
      signUpToken: signUpToken ?? this.signUpToken,
      message: message ?? this.message,
      seconds: seconds ?? this.seconds,
    );
  }

  @override
  List<Object?> get props => [
    signUpStatus,
    resendStatus,
    verifyStatus,
    email,
    signUpToken,
    message,
    seconds,
  ];
}
