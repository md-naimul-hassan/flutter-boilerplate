import 'package:flutter/foundation.dart';

import '../../../../app/constants/api_end_point.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/socket/socket_service.dart';
import '../../../../core/storage/storage_services.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<List<ChatModel>> fetchChats(int page);

  Future<List<MessageModel>> fetchMessages({
    required String chatId,
    required int page,
  });

  void sendMessage({
    required String chatId,
    required String text,
    void Function(dynamic data)? onAck,
  });

  void listenChatListUpdates(void Function(List<ChatModel>) onUpdate);

  void listenNewMessages(String chatId, void Function(MessageModel) onMessage);

  void stopListenNewMessages(String chatId);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  const MessageRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<ChatModel>> fetchChats(int page) async {
    final response = await _apiClient.get('${ApiEndPoint.chats}?page=$page');

    if (!response.isSuccess) {
      throw ApiException(response.statusCode, response.message);
    }

    final List<dynamic> data = response.data['chats'] ?? [];
    return data.map((e) => ChatModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageModel>> fetchMessages({
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

    return rawMessages.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
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

  @override
  void listenChatListUpdates(void Function(List<ChatModel>) onUpdate) {
    final userId = LocalStorage.user.id;
    SocketService.on('update-chatlist::$userId', (data) {
      final List<dynamic> list = data ?? [];
      onUpdate(list.map((e) => ChatModel.fromJson(e)).toList());
    });
  }

  @override
  void listenNewMessages(String chatId, void Function(MessageModel) onMessage) {
    SocketService.on('new-message::$chatId', (data) {
      onMessage(MessageModel.fromJson(data));
    });
  }

  @override
  void stopListenNewMessages(String chatId) {
    SocketService.off('new-message::$chatId');
  }
}
