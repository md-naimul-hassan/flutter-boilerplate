part of 'setting_bloc.dart';

class SettingState extends Equatable {
  const SettingState({this.status = ApiStatus.initial, this.message = ''});

  final ApiStatus status;
  final String message;

  SettingState copyWith({ApiStatus? status, String? message}) {
    return SettingState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
