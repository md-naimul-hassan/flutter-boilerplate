import '../../../../core/error/result.dart';
import '../entities/chat_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class MessageRepository {
  Future<Result<List<ChatEntity>>> getChats(int page);

  Future<Result<List<ChatMessageEntity>>> getMessages({
    required String chatId,
    required int page,
  });

  void sendMessage({required String chatId, required String text});

  void listenChatListUpdates(void Function(List<ChatEntity>) onUpdate);

  void listenNewMessages(
    String chatId,
    void Function(ChatMessageEntity) onMessage,
  );

  void stopListenNewMessages(String chatId);
}
