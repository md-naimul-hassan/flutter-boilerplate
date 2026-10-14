import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/storage_services.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_data_source.dart';
import '../models/message_model.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this._remoteDataSource);

  final MessageRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<ChatEntity>>> getChats(int page) async {
    try {
      return Success(await _remoteDataSource.fetchChats(page));
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  Future<Result<List<ChatMessageEntity>>> getMessages({
    required String chatId,
    required int page,
  }) async {
    try {
      final messages = await _remoteDataSource.fetchMessages(
        chatId: chatId,
        page: page,
      );
      return Success(messages.map(_toEntity).toList());
    } catch (e) {
      return Failed(catchFailure(e));
    }
  }

  @override
  void sendMessage({required String chatId, required String text}) {
    _remoteDataSource.sendMessage(chatId: chatId, text: text);
  }

  @override
  void listenChatListUpdates(void Function(List<ChatEntity>) onUpdate) {
    _remoteDataSource.listenChatListUpdates(onUpdate);
  }

  @override
  void listenNewMessages(
    String chatId,
    void Function(ChatMessageEntity) onMessage,
  ) {
    _remoteDataSource.listenNewMessages(
      chatId,
      (model) => onMessage(_toEntity(model, isMe: false)),
    );
  }

  @override
  void stopListenNewMessages(String chatId) {
    _remoteDataSource.stopListenNewMessages(chatId);
  }

  ChatMessageEntity _toEntity(MessageModel model, {bool? isMe}) {
    return ChatMessageEntity(
      time: model.createdAt.toLocal(),
      text: model.message,
      image: model.sender.image,
      isNotice: model.type == 'notice',
      isMe: isMe ?? LocalStorage.user.id == model.sender.id,
    );
  }
}
