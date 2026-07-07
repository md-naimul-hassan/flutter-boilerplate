import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/enum.dart';
import '../../../../../core/error/exceptions.dart';
import '../../data/datasources/remote_data_source.dart';
import 'events.dart';
import 'state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRemoteDataSource _remote;

  ChangePasswordBloc(this._remote) : super(const ChangePasswordState()) {
    on<ChangePasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));

    try {
      final message = await _remote.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(
        state.copyWith(status: ApiStatus.success, message: message),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: ApiStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
