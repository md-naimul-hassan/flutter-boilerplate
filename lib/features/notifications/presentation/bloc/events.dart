sealed class NotificationsEvent {}

class NotificationsStarted extends NotificationsEvent {}

class NotificationsLoadMore extends NotificationsEvent {}

class NotificationsRefreshed extends NotificationsEvent {}