import '../../../../../core/utils/enum.dart';
import '../../../data/models/chat_message_model.dart';

class MessageState {
  final Status status;
  final List<ChatMessageModel> messages;
  final bool isMoreLoading;
  final String name;

  const MessageState({
    this.status = Status.completed,
    this.messages = const [],
    this.isMoreLoading = false,
    this.name = '',
  });

  MessageState copyWith({
    Status? status,
    List<ChatMessageModel>? messages,
    bool? isMoreLoading,
    String? name,
  }) {
    return MessageState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      name: name ?? this.name,
    );
  }
}