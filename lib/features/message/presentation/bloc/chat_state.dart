part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.status = ApiStatus.initial,
    this.chats = const [],
    this.isMoreLoading = false,
  });

  final ApiStatus status;
  final List<ChatEntity> chats;
  final bool isMoreLoading;

  ChatState copyWith({
    ApiStatus? status,
    List<ChatEntity>? chats,
    bool? isMoreLoading,
  }) {
    return ChatState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    );
  }

  @override
  List<Object?> get props => [status, chats, isMoreLoading];
}
