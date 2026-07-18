import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/html_entity.dart';
import '../../domain/usecases/get_terms_of_services.dart';

part 'terms_of_services_event.dart';
part 'terms_of_services_state.dart';

class TermsOfServicesBloc
    extends Bloc<TermsOfServicesEvent, TermsOfServicesState> {
  TermsOfServicesBloc({required this._getTermsOfServices})
    : super(const TermsOfServicesState()) {
    on<TermsOfServicesRequested>(_onRequested);
  }

  final GetTermsOfServices _getTermsOfServices;

  Future<void> _onRequested(
    TermsOfServicesRequested event,
    Emitter<TermsOfServicesState> emit,
  ) async {
    emit(state.copyWith(status: ApiStatus.loading));

    final result = await _getTermsOfServices();

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: ApiStatus.success, data: data));
      case Failed():
        emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
