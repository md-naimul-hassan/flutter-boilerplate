import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants/api_end_point.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/html_model.dart';

/// Events
sealed class PrivacyPolicyEvent {}

class PrivacyPolicyRequested extends PrivacyPolicyEvent {}

/// State
class PrivacyPolicyState {
  final Status status;
  final HtmlModel data;

  PrivacyPolicyState({
    this.status = Status.completed,
    HtmlModel? data,
  }) : data = data ?? HtmlModel.fromJson({});

  PrivacyPolicyState copyWith({Status? status, HtmlModel? data}) {
    return PrivacyPolicyState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

/// Bloc
class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent, PrivacyPolicyState> {
  final ApiClient _apiClient;

  PrivacyPolicyBloc(this._apiClient) : super(PrivacyPolicyState()) {
    on<PrivacyPolicyRequested>(_onRequested);
  }

  Future<void> _onRequested(
    PrivacyPolicyRequested event,
    Emitter<PrivacyPolicyState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final response = await _apiClient.get(ApiEndPoint.privacyPolicies);

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
