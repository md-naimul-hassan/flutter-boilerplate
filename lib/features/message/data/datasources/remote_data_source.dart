import 'package:flutter/foundation.dart';

import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../../core/storage/storage_services.dart';
import '../models/chat_list_model.dart';
import '../models/chat_message_model.dart';
import '../models/message_model.dart';

class MessageRemoteDataSource {
  final ApiClient _apiClient;

  MessageRemoteDataSource(this._apiClient);

  Future<List<ChatModel>> fetchChats(int page) async {
    final response = await _apiClient.get('${ApiEndPoint.chats}?page=$page');

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final List<dynamic> data = response.data['chats'] ?? [];
    return data.map((e) => ChatModel.fromJson(e)).toList();
  }

  Future<List<ChatMessageModel>> fetchMessages({
    required String chatId,
    required int page,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndPoint.messages}?chatId=$chatId&page=$page&limit=15',
    );

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final Map<String, dynamic> data = response.data['data'] ?? {};
    final Map<String, dynamic> attributes = data['attributes'] ?? {};
    final List<dynamic> rawMessages = attributes['messages'] ?? [];

    return rawMessages
        .map((e) => _toChatMessage(MessageModel.fromJson(e)))
        .toList();
  }

  void sendMessage({
    required String chatId,
    required String text,
    void Function(dynamic data)? onAck,
  }) {
    SocketService.emitWithAck(
      'add-new-message',
      {'chat': chatId, 'message': text, 'sender': LocalStorage.user.id},
      onAck ??
          (data) {
            if (kDebugMode) debugPrint('Ack: $data');
          },
    );
  }

  void listenChatListUpdates(void Function(List<ChatModel>) onUpdate) {
    final userId = LocalStorage.user.id;
    SocketService.on('update-chatlist::$userId', (data) {
      final List<dynamic> list = data ?? [];
      onUpdate(list.map((e) => ChatModel.fromJson(e)).toList());
    });
  }

  void listenNewMessages(
    String chatId,
    void Function(ChatMessageModel) onMessage,
  ) {
    SocketService.on('new-message::$chatId', (data) {
      onMessage(_toChatMessage(MessageModel.fromJson(data), isMe: false));
    });
  }

  ChatMessageModel _toChatMessage(MessageModel model, {bool? isMe}) {
    return ChatMessageModel(
      time: model.createdAt.toLocal(),
      text: model.message,
      image: model.sender.image,
      isNotice: model.type == 'notice',
      isMe: isMe ?? LocalStorage.user.id == model.sender.id,
    );
  }
}
