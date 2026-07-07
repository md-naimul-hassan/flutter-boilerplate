import '../../../../../app/enum.dart';

class ChangePasswordState {
  final ApiStatus status;
  final String message;

  const ChangePasswordState({
    this.status = ApiStatus.initial,
    this.message = '',
  });

  ChangePasswordState copyWith({
    ApiStatus? status,
    String? message,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}