import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/api_end_point.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/html_model.dart';

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
  final ApiClient _apiClient;

  TermsOfServicesBloc(this._apiClient) : super(TermsOfServicesState()) {
    on<TermsOfServicesRequested>(_onRequested);
  }

  Future<void> _onRequested(
    TermsOfServicesRequested event,
    Emitter<TermsOfServicesState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final response = await _apiClient.get(ApiEndPoint.termsOfServices);

      if (response.statusCode != 200) {
        throw Exception(response.message);
      }

      final Map<String, dynamic> rawData = response.data['data'] ?? {};
      final Map<String, dynamic> raw = rawData['attributes'] ?? {};

      emit(
        state.copyWith(status: Status.completed, data: HtmlModel.fromJson(raw)),
      );
    } catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
