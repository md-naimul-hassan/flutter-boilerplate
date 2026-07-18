part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsStarted extends NotificationsEvent {
  const NotificationsStarted();
}

class NotificationsLoadMore extends NotificationsEvent {
  const NotificationsLoadMore();
}

class NotificationsRefreshed extends NotificationsEvent {
  const NotificationsRefreshed();
}
