part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({this.status = ApiStatus.initial, this.message = ''});

  final ApiStatus status;
  final String message;

  SignInState copyWith({ApiStatus? status, String? message}) {
    return SignInState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
