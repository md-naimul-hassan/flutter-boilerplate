part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  const ChatStarted();
}

class ChatLoadMore extends ChatEvent {
  const ChatLoadMore();
}

class ChatRefreshed extends ChatEvent {
  const ChatRefreshed();
}

class ChatListUpdated extends ChatEvent {
  const ChatListUpdated(this.chats);

  final List<ChatEntity> chats;

  @override
  List<Object?> get props => [chats];
}
