import '../../../../../app/enum.dart';

class SignInState {
  final ApiStatus status;
  final String message;

  const SignInState({this.status = ApiStatus.initial, this.message = ''});

  SignInState copyWith({ApiStatus? status, String? message}) {
    return SignInState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
