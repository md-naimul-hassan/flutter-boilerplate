import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../data/datasources/remote_data_source.dart';

/// Events
sealed class SettingEvent {}

class SettingDeleteAccountRequested extends SettingEvent {
  final String password;
  SettingDeleteAccountRequested(this.password);
}

/// State
class SettingState {
  final ApiStatus status;
  final String message;

  const SettingState({this.status = ApiStatus.initial, this.message = ''});

  SettingState copyWith({ApiStatus? status, String? message}) {
    return SettingState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

/// Bloc
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRemoteDataSource _remote;

  SettingBloc(this._remote) : super(const SettingState()) {
    on<SettingDeleteAccountRequested>(_onDeleteAccount);
  }

  Future<void> _onDeleteAccount(
    SettingDeleteAccountRequested event,
    Emitter<SettingState> emit,
  ) async {
    final password = event.password.trim();
    if (password.isEmpty) {
      emit(
        state.copyWith(
          status: ApiStatus.failure,
          message: 'Password required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ApiStatus.loading));

    try {
      await _remote.deleteAccount(password);
      emit(state.copyWith(status: ApiStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, message: e.toString()));
    }
  }
}
