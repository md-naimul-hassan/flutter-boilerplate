import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/result.dart';
import '../../domain/usecases/change_password.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc({required this._changePassword})
    : super(const ChangePasswordState()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  final ChangePassword _changePassword;

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    if (state.status == ApiStatus.loading) return;
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _changePassword(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: ApiStatus.success, message: data));
      case Failed(:final failure):
        emit(
          state.copyWith(status: ApiStatus.failure, message: failure.message),
        );
    }
  }
}
