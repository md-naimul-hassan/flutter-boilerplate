import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/enum.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/html_model.dart';

/// Events
sealed class TermsOfServicesEvent {}

class TermsOfServicesRequested extends TermsOfServicesEvent {}

/// State
class TermsOfServicesState {
  final ApiStatus status;
  final HtmlModel data;

  TermsOfServicesState({
    this.status = ApiStatus.success,
    HtmlModel? data,
  }) : data = data ?? HtmlModel.fromJson({});

  TermsOfServicesState copyWith({ApiStatus? status, HtmlModel? data}) {
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
    emit(state.copyWith(status: ApiStatus.loading));

    try {
      final data = await _remote.fetchTermsOfServices();
      emit(state.copyWith(status: ApiStatus.success, data: data));
    } catch (_) {
      emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
