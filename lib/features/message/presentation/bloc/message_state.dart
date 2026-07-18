part of 'message_bloc.dart';

class MessageState extends Equatable {
  const MessageState({
    this.status = ApiStatus.initial,
    this.messages = const [],
    this.isMoreLoading = false,
    this.name = '',
  });

  final ApiStatus status;
  final List<ChatMessageEntity> messages;
  final bool isMoreLoading;
  final String name;

  MessageState copyWith({
    ApiStatus? status,
    List<ChatMessageEntity>? messages,
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

  @override
  List<Object?> get props => [status, messages, isMoreLoading, name];
}
