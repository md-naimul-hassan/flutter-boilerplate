import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/html_entity.dart';
import '../../domain/usecases/get_privacy_policy.dart';

part 'privacy_policy_event.dart';
part 'privacy_policy_state.dart';

class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  PrivacyPolicyBloc({required this._getPrivacyPolicy})
    : super(const PrivacyPolicyState()) {
    on<PrivacyPolicyRequested>(_onRequested);
  }

  final GetPrivacyPolicy _getPrivacyPolicy;

  Future<void> _onRequested(
    PrivacyPolicyRequested event,
    Emitter<PrivacyPolicyState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _getPrivacyPolicy();

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: ApiStatus.success, data: data));
      case Failed():
        emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
