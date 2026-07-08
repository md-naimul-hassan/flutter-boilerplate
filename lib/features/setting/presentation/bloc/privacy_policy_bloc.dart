import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/enum.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/html_model.dart';

/// Events
sealed class PrivacyPolicyEvent {}

class PrivacyPolicyRequested extends PrivacyPolicyEvent {}

/// State
class PrivacyPolicyState {
  final ApiStatus status;
  final HtmlModel data;

  PrivacyPolicyState({
    this.status = ApiStatus.initial,
    HtmlModel? data,
  }) : data = data ?? HtmlModel.fromJson({});

  PrivacyPolicyState copyWith({ApiStatus? status, HtmlModel? data}) {
    return PrivacyPolicyState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

/// Bloc
class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final SettingRemoteDataSource _remote;

  PrivacyPolicyBloc(this._remote) : super(PrivacyPolicyState()) {
    on<PrivacyPolicyRequested>(_onRequested);
  }

  Future<void> _onRequested(
    PrivacyPolicyRequested event,
    Emitter<PrivacyPolicyState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));

    try {
      final data = await _remote.fetchPrivacyPolicy();
      emit(state.copyWith(status: ApiStatus.success, data: data));
    } catch (_) {
      emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
