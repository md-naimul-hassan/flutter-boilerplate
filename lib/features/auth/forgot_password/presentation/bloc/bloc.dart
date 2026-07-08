import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/exceptions.dart';
import '../../data/datasources/remote_data_source.dart';
import 'events.dart';
import 'state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRemoteDataSource _remote;

  static const int _otpDurationSeconds = 180;
  Timer? _timer;

  ForgotPasswordBloc(this._remote) : super(const ForgotPasswordState()) {
    on<ForgotSendEmailRequested>(_onSendEmail);
    on<ForgotVerifyOtpRequested>(_onVerifyOtp);
    on<ForgotResetPasswordRequested>(_onResetPassword);
    on<ForgotTimerStarted>(_onTimerStarted);
    on<ForgotTicked>(_onTicked);
  }

  Future<void> _onSendEmail(
    ForgotSendEmailRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(sendStatus: ApiStatus.loading, email: event.email));

    try {
      final message = await _remote.sendResetEmail(email: event.email);
      emit(state.copyWith(sendStatus: ApiStatus.success, message: message));
      add(ForgotTimerStarted());
    } on ApiException catch (e) {
      emit(state.copyWith(sendStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(sendStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onVerifyOtp(
    ForgotVerifyOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.verifyStatus == ApiStatus.loading) return;
    emit(state.copyWith(verifyStatus: ApiStatus.loading));

    try {
      final token = await _remote.verifyOtp(email: state.email, otp: event.otp);
      emit(
        state.copyWith(
          verifyStatus: ApiStatus.success,
          forgetPasswordToken: token,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(verifyStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(verifyStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onResetPassword(
    ForgotResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.resetStatus == ApiStatus.loading) return;
    emit(state.copyWith(resetStatus: ApiStatus.loading));

    try {
      if (event.password != event.confirmPassword) {
        emit(
          state.copyWith(
            resetStatus: ApiStatus.failure,
            message: 'Passwords do not match',
          ),
        );
        return;
      }

      final message = await _remote.resetPassword(
        email: state.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        token: state.forgetPasswordToken,
      );
      _timer?.cancel();
      emit(state.copyWith(resetStatus: ApiStatus.success, message: message));
    } on ApiException catch (e) {
      emit(state.copyWith(resetStatus: ApiStatus.failure, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(resetStatus: ApiStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _onTimerStarted(
    ForgotTimerStarted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    _timer?.cancel();
    emit(state.copyWith(seconds: _otpDurationSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.seconds - 1;
      if (next <= 0) {
        _timer?.cancel();
        add(ForgotTicked(0));
      } else {
        add(ForgotTicked(next));
      }
    });
  }

  void _onTicked(ForgotTicked event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(seconds: event.seconds));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
