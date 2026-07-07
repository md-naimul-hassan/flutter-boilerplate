import '../../../data/models/chat_list_model.dart';

sealed class ChatEvent {}

class ChatStarted extends ChatEvent {}

class ChatLoadMore extends ChatEvent {}

class ChatRefreshed extends ChatEvent {}

class ChatListUpdated extends ChatEvent {
  final List<ChatModel> chats;

  ChatListUpdated(this.chats);
}
