part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.status = ApiStatus.initial,
    this.message = '',
  });

  final ApiStatus status;
  final String message;

  ChangePasswordState copyWith({ApiStatus? status, String? message}) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
