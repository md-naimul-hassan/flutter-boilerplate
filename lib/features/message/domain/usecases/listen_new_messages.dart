import '../entities/chat_message_entity.dart';
import '../repositories/message_repository.dart';

class ListenNewMessages {
  const ListenNewMessages(this._repository);

  final MessageRepository _repository;

  void call(String chatId, void Function(ChatMessageEntity) onMessage) {
    _repository.listenNewMessages(chatId, onMessage);
  }
}
