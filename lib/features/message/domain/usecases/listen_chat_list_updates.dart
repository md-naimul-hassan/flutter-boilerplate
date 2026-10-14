import '../entities/chat_entity.dart';
import '../repositories/message_repository.dart';

class ListenChatListUpdates {
  const ListenChatListUpdates(this._repository);

  final MessageRepository _repository;

  void call(void Function(List<ChatEntity>) onUpdate) {
    _repository.listenChatListUpdates(onUpdate);
  }
}
