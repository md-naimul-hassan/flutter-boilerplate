import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/services/socket/socket_service.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/exceptions.dart';
import '../../data/datasources/remote_data_source.dart';
import 'events.dart';
import 'state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRemoteDataSource _remote;

  SignInBloc(this._remote) : super(const SignInState()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.status == ApiStatus.loading) return;

    emit(state.copyWith(status: ApiStatus.loading));

    try {
      await _remote.signIn(email: event.email, password: event.password);
      SocketService.connect();
      emit(state.copyWith(status: ApiStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(state.copyWith(status: ApiStatus.failure, message: e.toString()));
    }
  }
}
