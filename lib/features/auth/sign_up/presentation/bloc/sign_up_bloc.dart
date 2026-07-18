import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/enum.dart';
import '../../../../../core/error/result.dart';
import '../../domain/usecases/resend_sign_up_otp.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/verify_email.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required this._signUp,
    required this._resendOtp,
    required this._verifyEmail,
  }) : super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpOtpSubmitted>(_onOtpSubmitted);
    on<ResendOtpRequested>(_onResend);
    on<SignUpTimerStarted>(_onTimerStarted);
    on<SignUpTicked>(_onTicked);
  }

  final SignUp _signUp;
  final ResendSignUpOtp _resendOtp;
  final VerifyEmail _verifyEmail;

  static const int _otpDurationSeconds = 180;
  Timer? _timer;

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.signUpStatus == ApiStatus.loading) return;

    emit(state.copyWith(signUpStatus: ApiStatus.loading, email: event.email));

    final result = await _signUp(
      name: event.name.trim(),
      email: event.email.trim(),
      password: event.password.trim(),
    );

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(signUpStatus: ApiStatus.success, signUpToken: data),
        );
      case Failed(:final failure):
        emit(
          state.copyWith(
            signUpStatus: ApiStatus.failure,
            message: failure.message,
          ),
        );
    }
  }

  Future<void> _onOtpSubmitted(
    SignUpOtpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.verifyStatus == ApiStatus.loading) return;

    emit(state.copyWith(verifyStatus: ApiStatus.loading));

    final result = await _verifyEmail(
      otp: event.otp.trim(),
      signUpToken: state.signUpToken.trim(),
    );

    switch (result) {
      case Success():
        emit(state.copyWith(verifyStatus: ApiStatus.success));
      case Failed(:final failure):
        emit(
          state.copyWith(
            verifyStatus: ApiStatus.failure,
            message: failure.message,
          ),
        );
    }
  }

  Future<void> _onResend(
    ResendOtpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.resendStatus == ApiStatus.loading) return;
    emit(state.copyWith(resendStatus: ApiStatus.loading));

    final result = await _resendOtp(email: event.email);

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(resendStatus: ApiStatus.success, signUpToken: data),
        );
        add(const SignUpTimerStarted());
      case Failed(:final failure):
        emit(
          state.copyWith(
            resendStatus: ApiStatus.failure,
            message: failure.message,
          ),
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
        add(const SignUpTicked(0));
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
