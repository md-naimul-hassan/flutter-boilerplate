import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/result.dart';
import '../../../../../core/services/socket/socket_service.dart';
import '../../domain/usecases/sign_in.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required this._signIn}) : super(const SignInState()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  final SignIn _signIn;

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.status == ApiStatus.loading) return;

    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _signIn(email: event.email, password: event.password);

    switch (result) {
      case Success():
        SocketService.connect();
        emit(state.copyWith(status: ApiStatus.success));
      case Failed(:final failure):
        emit(
          state.copyWith(status: ApiStatus.failure, message: failure.message),
        );
    }
  }
}
