import 'package:flutter_bloc/flutter_bloc.dart';

import './events.dart';
import './state.dart';
import '../../data/datasources/remote_data_source.dart';


class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRemoteDataSource _remote;
  int _page = 1;

  NotificationsBloc(this._remote) : super(const NotificationsState()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsLoadMore>(_onLoadMore);
    on<NotificationsRefreshed>(_onRefreshed);
  }

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
    try {
      final list = await _remote.fetchNotifications(_page);
      if (list.isEmpty) {
        emit(state.copyWith(hasNoData: true));
      } else {
        _page++;
        emit(state.copyWith(notifications: [...state.notifications, ...list]));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
