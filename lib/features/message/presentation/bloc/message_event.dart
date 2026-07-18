part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class MessageStarted extends MessageEvent {
  const MessageStarted({required this.chatId, required this.name});

  final String chatId;
  final String name;

  @override
  List<Object?> get props => [chatId, name];
}

class MessageClosed extends MessageEvent {
  const MessageClosed({required this.chatId});

  final String chatId;

  @override
  List<Object?> get props => [chatId];
}

class MessageLoadMore extends MessageEvent {
  const MessageLoadMore();
}

class MessageSent extends MessageEvent {
  const MessageSent(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

class MessageReceived extends MessageEvent {
  const MessageReceived(this.message);

  final ChatMessageEntity message;

  @override
  List<Object?> get props => [message];
}
