import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../../core/storeage/storage_services.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/chat_list_model.dart';
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/utils/app_snackbar.dart';

class ChatController extends GetxController {
  Status status = Status.completed;
  bool isMoreLoading = false;
  int page = 1;
  final List<ChatModel> chats = [];

  final ApiClient apiClient = DioApiClient();

  /// Scroll controller
  final ScrollController scrollController = ScrollController();

  /// Get controller instance
  static ChatController get instance => Get.find<ChatController>();

  /// Init controller
  @override
  void onInit() {
    super.onInit();
    getChats();
    listenChat();
    scrollController.addListener(_onScroll);
  }

  /// Scroll listener for pagination
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      moreChats();
    }
  }

  /// Load more chats when reach bottom
  Future<void> moreChats() async {
    if (isMoreLoading || status == Status.loading) return;

    try {
      isMoreLoading = true;
      update();
      await getChats();
    } finally {
      isMoreLoading = false;
      update();
    }
  }

  /// Fetch chats from API
  Future<void> getChats() async {
    return;
    try {
      if (page == 1) {
        status = Status.loading;
        update();
      }

      final response = await apiClient.get('${ApiEndPoint.chats}?page=$page');

      if (response.statusCode != 200) {
        throw Exception(response.message);
      }

      final List<dynamic> data = response.data['chats'] ?? [];
      final newChats = data.map((e) => ChatModel.fromJson(e)).toList();
      chats.addAll(newChats);
      page++;
      status = Status.completed;
    } catch (e) {
      status = Status.error;
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      update();
    }
  }

  /// Listen chat updates from socket
  void listenChat() {
    final userId = LocalStorage.user.id;
    SocketService.on('update-chatlist::$userId', (data) {
      page = 1;
      chats.clear();
      final List<dynamic> list = data ?? [];
      chats.addAll(list.map((e) => ChatModel.fromJson(e)).toList());
      status = Status.completed;
      update();
    });
  }

  /// Refresh chats manually
  Future<void> refreshChats() async {
    page = 1;
    chats.clear();
    await getChats();
  }

  /// Dispose controller
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
