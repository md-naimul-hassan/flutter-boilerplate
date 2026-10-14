import '../repositories/message_repository.dart';

class SendMessage {
  const SendMessage(this._repository);

  final MessageRepository _repository;

  void call({required String chatId, required String text}) {
    _repository.sendMessage(chatId: chatId, text: text);
  }
}
