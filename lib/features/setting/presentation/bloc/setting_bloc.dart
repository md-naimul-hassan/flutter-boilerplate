import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/delete_account.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required this._deleteAccount}) : super(const SettingState()) {
    on<SettingDeleteAccountRequested>(_onDeleteAccount);
  }

  final DeleteAccount _deleteAccount;

  Future<void> _onDeleteAccount(
    SettingDeleteAccountRequested event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));

    final password = event.password.trim();
    if (password.isEmpty) {
      emit(
        state.copyWith(status: ApiStatus.failure, message: 'Password required'),
      );
      return;
    }

    final result = await _deleteAccount(password);

    switch (result) {
      case Success():
        emit(state.copyWith(status: ApiStatus.success));
      case Failed(:final failure):
        emit(
          state.copyWith(status: ApiStatus.failure, message: failure.message),
        );
    }
  }
}
