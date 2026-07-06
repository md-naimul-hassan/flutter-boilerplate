import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/utils/app_snackbar.dart';

import '../../data/model/notification_model.dart';
import '../../repository/notification_repository.dart';

class NotificationsController extends GetxController {
  /// Notification list
  final List<NotificationModel> notifications = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasNoData = false;
  int page = 1;

  /// Scroll controller
  final ScrollController scrollController = ScrollController();

  /// Get instance
  static NotificationsController get instance =>
      Get.find<NotificationsController>();

  /// Init
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    getNotifications();
  }

  /// Scroll listener
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  /// Fetch notifications (first load)
  Future<void> getNotifications() async {
    if (isLoading) return;
    try {
      isLoading = true;
      update();

      final list = await notificationRepository(page);

      if (list.isEmpty) {
        hasNoData = true;
      } else {
        notifications.addAll(list);
        page++;
      }
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore || hasNoData) return;

    try {
      isLoadingMore = true;
      update();

      final list = await notificationRepository(page);

      if (list.isEmpty) {
        hasNoData = true;
      } else {
        notifications.addAll(list);
        page++;
      }
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  /// Refresh manually
  @override
  Future<void> refresh() async {
    page = 1;
    hasNoData = false;
    notifications.clear();
    await getNotifications();
  }

  /// Dispose
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
