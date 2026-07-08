import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enum.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/html_model.dart';

/// Events
sealed class TermsOfServicesEvent {}

class TermsOfServicesRequested extends TermsOfServicesEvent {}

/// State
class TermsOfServicesState {
  final Status status;
  final HtmlModel data;

  TermsOfServicesState({
    this.status = Status.completed,
    HtmlModel? data,
  }) : data = data ?? HtmlModel.fromJson({});

  TermsOfServicesState copyWith({Status? status, HtmlModel? data}) {
    return TermsOfServicesState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

/// Bloc
class TermsOfServicesBloc
    extends Bloc<TermsOfServicesEvent, TermsOfServicesState> {
  final SettingRemoteDataSource _remote;

  TermsOfServicesBloc(this._remote) : super(TermsOfServicesState()) {
    on<TermsOfServicesRequested>(_onRequested);
  }

  Future<void> _onRequested(
    TermsOfServicesRequested event,
    Emitter<TermsOfServicesState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final data = await _remote.fetchTermsOfServices();
      emit(state.copyWith(status: Status.completed, data: data));
    } catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
