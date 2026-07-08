import '../../../data/models/chat_message_model.dart';

sealed class MessageEvent {}

class MessageStarted extends MessageEvent {
  final String chatId;
  final String name;

  MessageStarted({required this.chatId, required this.name});
}

class MessageClosed extends MessageEvent {
  final String chatId;

  MessageClosed({required this.chatId});
}

class MessageLoadMore extends MessageEvent {}

class MessageSent extends MessageEvent {
  final String text;

  MessageSent(this.text);
}

class MessageReceived extends MessageEvent {
  final ChatMessageModel message;

  MessageReceived(this.message);
}
