import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../../core/storeage/storage_services.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/logger.dart';
import '../../data/model/chat_message_model.dart';
import '../../data/model/message_model.dart';
import '../../../../app/constants/api_end_point.dart';
import '../../../../core/utils/app_snackbar.dart';

class MessageController extends GetxController {
  /// Controller instance
  static MessageController get instance => Get.find<MessageController>();

  final ApiClient apiClient = DioApiClient();

  Status status = Status.completed;
  bool isLoading = false;
  bool isMoreLoading = false;
  String chatId = '';
  String name = '';
  int page = 1;
  bool isInputField = false;
  int currentIndex = 0;
  final List<ChatMessageModel> messages = [];

  /// Scroll & text controller
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  /// Init
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  /// Scroll listener for pagination
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      loadMoreMessages();
    }
  }

  /// Fetch messages from API
  Future<void> getMessages() async {
    try {
      if (page == 1) {
        messages.clear();
        status = Status.loading;
        update();
      }

      final response = await apiClient.get(
        '${ApiEndPoint.messages}?chatId=$chatId&page=$page&limit=15',
      );

      if (response.statusCode != 200) {
        throw Exception(response.message);
      }

      final Map<String, dynamic> data = response.data['data'] ?? {};
      final Map<String, dynamic> attributes = data['attributes'] ?? {};
      final List<dynamic> rawMessages = attributes['messages'] ?? [];

      final newMessages = rawMessages.map((e) {
        final model = MessageModel.fromJson(e);

        return ChatMessageModel(
          time: model.createdAt.toLocal(),
          text: model.message,
          image: model.sender.image,
          isNotice: model.type == 'notice',
          isMe: LocalStorage.user.id == model.sender.id,
        );
      }).toList();

      messages.addAll(newMessages);

      page++;
      status = Status.completed;
    } catch (e) {
      status = Status.error;

      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      update();
    }
  }

  /// Load more messages (pagination)
  Future<void> loadMoreMessages() async {
    if (isMoreLoading || status == Status.loading) return;

    try {
      isMoreLoading = true;
      update();

      await getMessages();
    } catch (e) {
      logError(e.toString());
    } finally {
      isMoreLoading = false;
      update();
    }
  }

  /// Send new message (socket)
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    /// Add locally for instant UI
    messages.insert(
      0,
      ChatMessageModel(
        time: DateTime.now(),
        text: text,
        image: LocalStorage.user.image,
        isMe: true,
      ),
    );

    update();

    final body = {
      'chat': chatId,
      'message': text,
      'sender': LocalStorage.user.id,
    };

    messageController.clear();

    SocketService.emitWithAck('add-new-message', body, (data) {
      if (kDebugMode) {
        debugPrint('Ack: $data');
      }
    });
  }

  /// Listen socket new messages
  void listenMessage(String chatId) {
    SocketService.on('new-message::$chatId', (data) {
      final model = MessageModel.fromJson(data);

      messages.insert(
        0,
        ChatMessageModel(
          time: model.createdAt.toLocal(),
          text: model.message,
          image: model.sender.image,
          isNotice: model.type == 'notice',
          isMe: false,
        ),
      );

      update();
    });
  }

  /// Toggle emoji/input
  void toggleInput(int index) {
    currentIndex = index;
    isInputField = !isInputField;
    update();
  }

  /// Refresh messages manually
  @override
  Future<void> refresh() async {
    page = 1;
    await getMessages();
  }

  /// Dispose
  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
