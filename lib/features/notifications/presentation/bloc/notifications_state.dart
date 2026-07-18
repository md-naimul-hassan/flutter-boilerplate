part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasNoData = false,
    this.error,
  });

  final List<NotificationEntity> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasNoData;
  final String? error;

  /// [error] is not carried over, so each failure is reported once.
  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNoData,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNoData: hasNoData ?? this.hasNoData,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    isLoading,
    isLoadingMore,
    hasNoData,
    error,
  ];
}
