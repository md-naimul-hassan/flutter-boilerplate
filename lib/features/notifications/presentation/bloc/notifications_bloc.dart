import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({required this._getNotifications})
    : super(const NotificationsState()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsLoadMore>(_onLoadMore);
    on<NotificationsRefreshed>(_onRefreshed);
  }

  final GetNotifications _getNotifications;
  int _page = 1;

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    await _load(emit);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onLoadMore(
    NotificationsLoadMore event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state.isLoadingMore || state.hasNoData) return;
    emit(state.copyWith(isLoadingMore: true));
    await _load(emit);
    emit(state.copyWith(isLoadingMore: false));
  }

  Future<void> _onRefreshed(
    NotificationsRefreshed event,
    Emitter<NotificationsState> emit,
  ) async {
    _page = 1;
    emit(const NotificationsState(isLoading: true));
    await _load(emit);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _load(Emitter<NotificationsState> emit) async {
    final result = await _getNotifications(_page);

    switch (result) {
      case Success(:final data) when data.isEmpty:
        emit(state.copyWith(hasNoData: true));
      case Success(:final data):
        _page++;
        emit(state.copyWith(notifications: [...state.notifications, ...data]));
      case Failed(:final failure):
        emit(state.copyWith(error: failure.message));
    }
  }
}
