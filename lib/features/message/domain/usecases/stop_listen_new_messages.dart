import '../repositories/message_repository.dart';

class StopListenNewMessages {
  const StopListenNewMessages(this._repository);

  final MessageRepository _repository;

  void call(String chatId) => _repository.stopListenNewMessages(chatId);
}
