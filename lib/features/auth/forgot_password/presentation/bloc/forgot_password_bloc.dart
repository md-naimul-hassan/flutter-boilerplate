import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/result.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/send_reset_email.dart';
import '../../domain/usecases/verify_reset_otp.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required this._sendResetEmail,
    required this._verifyResetOtp,
    required this._resetPassword,
  }) : super(const ForgotPasswordState()) {
    on<ForgotSendEmailRequested>(_onSendEmail);
    on<ForgotResendOtpRequested>(_onResendOtp);
    on<ForgotVerifyOtpRequested>(_onVerifyOtp);
    on<ForgotResetPasswordRequested>(_onResetPassword);
    on<ForgotTimerStarted>(_onTimerStarted);
    on<ForgotTicked>(_onTicked);
  }

  final SendResetEmail _sendResetEmail;
  final VerifyResetOtp _verifyResetOtp;
  final ResetPassword _resetPassword;

  static const int _otpDurationSeconds = 180;
  Timer? _timer;

  Future<void> _onSendEmail(
    ForgotSendEmailRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(sendStatus: ApiStatus.loading, email: event.email));

    final result = await _sendResetEmail(email: event.email);

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(sendStatus: ApiStatus.success, message: data));
        add(const ForgotTimerStarted());
      case Failed(:final failure):
        emit(
          state.copyWith(
            sendStatus: ApiStatus.failure,
            message: failure.message,
          ),
        );
    }
  }

  Future<void> _onResendOtp(
    ForgotResendOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.resendStatus == ApiStatus.loading) return;
    emit(state.copyWith(resendStatus: ApiStatus.loading));

    final result = await _sendResetEmail(email: state.email);

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(resendStatus: ApiStatus.success, message: data));
        add(const ForgotTimerStarted());
      case Failed(:final failure):
        emit(
          state.copyWith(
            resendStatus: ApiStatus.failure,
            message: failure.message,
          ),
        );
    }
  }

  Future<void> _onVerifyOtp(
    ForgotVerifyOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.verifyStatus == ApiStatus.loading) return;
    emit(state.copyWith(verifyStatus: ApiStatus.loading));

    final result = await _verifyResetOtp(email: state.email, otp: event.otp);

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.success,
            forgetPasswordToken: data,
          ),
        );
      case Failed(:final failure):
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.failure,
            message: failure.message,
          ),
        );
    }
  }

  Future<void> _onResetPassword(
    ForgotResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.resetStatus == ApiStatus.loading) return;
    emit(state.copyWith(resetStatus: ApiStatus.loading));

    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          resetStatus: ApiStatus.failure,
          message: 'Passwords do not match',
        ),
      );
      return;
    }

    final result = await _resetPassword(
      email: state.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      token: state.forgetPasswordToken,
    );

    switch (result) {
      case Success(:final data):
        _timer?.cancel();
        emit(state.copyWith(resetStatus: ApiStatus.success, message: data));
      case Failed(:final failure):
        emit(
          state.copyWith(
            resetStatus: ApiStatus.failure,
            message: failure.message,
          ),
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
        add(const ForgotTicked(0));
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
