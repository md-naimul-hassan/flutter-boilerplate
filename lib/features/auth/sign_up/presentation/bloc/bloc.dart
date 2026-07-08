import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/exceptions.dart';
import '../../data/datasources/remote_data_source.dart';
import 'events.dart';
import 'state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRemoteDataSource _remote;

  static const int _otpDurationSeconds = 180;
  Timer? _timer;

  SignUpBloc(this._remote) : super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpOtpSubmitted>(_onOtpSubmitted);
    on<ResendOtpRequested>(_onResend);
    on<SignUpTimerStarted>(_onTimerStarted);
    on<SignUpTicked>(_onTicked);
  }

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.signUpStatus == ApiStatus.loading) return;

    emit(state.copyWith(signUpStatus: ApiStatus.loading, email: event.email));

    try {
      final token = await _remote.signUp(
        name: event.name.trim(),
        email: event.email.trim(),
        password: event.password.trim(),
      );
      emit(state.copyWith(signUpStatus: ApiStatus.success, signUpToken: token));
    } on ApiException catch (e) {
      emit(state.copyWith(signUpStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(signUpStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onOtpSubmitted(
    SignUpOtpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.verifyStatus == ApiStatus.loading) return;

    emit(state.copyWith(verifyStatus: ApiStatus.loading));

    try {
      await _remote.verifyEmail(
        otp: event.otp.trim(),
        signUpToken: state.signUpToken.trim(),
      );
      emit(state.copyWith(verifyStatus: ApiStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(verifyStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(verifyStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onResend(
    ResendOtpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    add(SignUpTimerStarted());

    try {
      final token = await _remote.resendOtp(email: event.email);
      emit(state.copyWith(signUpStatus: ApiStatus.success, signUpToken: token));
    } on ApiException catch (e) {
      emit(state.copyWith(signUpStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(signUpStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onTimerStarted(
    SignUpTimerStarted event,
    Emitter<SignUpState> emit,
  ) async {
    _timer?.cancel();
    emit(state.copyWith(seconds: _otpDurationSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.seconds - 1;
      if (next <= 0) {
        _timer?.cancel();
        add(SignUpTicked(0));
      } else {
        add(SignUpTicked(next));
      }
    });
  }

  void _onTicked(SignUpTicked event, Emitter<SignUpState> emit) {
    emit(state.copyWith(seconds: event.seconds));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
