import '../../../../../core/utils/enum.dart';
import '../../../data/models/chat_list_model.dart';

class ChatState {
  final Status status;
  final List<ChatModel> chats;
  final bool isMoreLoading;

  const ChatState({
    this.status = Status.completed,
    this.chats = const [],
    this.isMoreLoading = false,
  });

  ChatState copyWith({
    Status? status,
    List<ChatModel>? chats,
    bool? isMoreLoading,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    );
  }
}