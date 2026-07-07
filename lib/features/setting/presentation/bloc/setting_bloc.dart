import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/api_end_point.dart';
import '../../../../app/enum.dart';
import '../../../../core/network/api_client.dart';

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
  final ApiClient _apiClient;

  SettingBloc(this._apiClient) : super(const SettingState()) {
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
      final response = await _apiClient.delete(
        ApiEndPoint.user,
        body: {'password': password},
      );

      if (!response.isSuccess) {
        throw Exception(response.message);
      }

      emit(state.copyWith(status: ApiStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, message: e.toString()));
    }
  }
}
