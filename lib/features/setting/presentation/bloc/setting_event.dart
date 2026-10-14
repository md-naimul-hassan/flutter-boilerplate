part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class SettingDeleteAccountRequested extends SettingEvent {
  const SettingDeleteAccountRequested(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}
