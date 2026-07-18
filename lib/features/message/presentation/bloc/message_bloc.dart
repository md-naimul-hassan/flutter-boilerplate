import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../../../core/storage/storage_services.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/listen_new_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/stop_listen_new_messages.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc({
    required this._getMessages,
    required this._sendMessage,
    required this._listenNewMessages,
    required this._stopListenNewMessages,
  }) : super(const MessageState()) {
    on<MessageStarted>(_onStarted);
    on<MessageClosed>(_onClosed);
    on<MessageLoadMore>(_onLoadMore);
    on<MessageSent>(_onSent);
    on<MessageReceived>(_onReceived);
  }

  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  final ListenNewMessages _listenNewMessages;
  final StopListenNewMessages _stopListenNewMessages;
  String _chatId = '';
  int _page = 1;

  Future<void> _onStarted(
    MessageStarted event,
    Emitter<MessageState> emit,
  ) async {
    _chatId = event.chatId;
    emit(state.copyWith(name: event.name));
    _listenNewMessages(
      event.chatId,
      (message) => add(MessageReceived(message)),
    );
    await _fetch(emit, initial: true);
  }

  Future<void> _onClosed(
    MessageClosed event,
    Emitter<MessageState> emit,
  ) async {
    _chatId = event.chatId;
    _stopListenNewMessages(event.chatId);
  }

  Future<void> _onLoadMore(
    MessageLoadMore event,
    Emitter<MessageState> emit,
  ) async {
    if (state.isMoreLoading || state.status == ApiStatus.loading) return;
    emit(state.copyWith(isMoreLoading: true));
    await _fetch(emit);
    emit(state.copyWith(isMoreLoading: false));
  }

  Future<void> _fetch(
    Emitter<MessageState> emit, {
    bool initial = false,
  }) async {
    if (initial) {
      emit(state.copyWith(status: ApiStatus.loading, messages: []));
    }

    final result = await _getMessages(chatId: _chatId, page: _page);

    switch (result) {
      case Success(:final data):
        _page++;
        emit(
          state.copyWith(
            status: ApiStatus.success,
            messages: [...state.messages, ...data],
          ),
        );
      case Failed():
        emit(state.copyWith(status: ApiStatus.failure));
    }
  }

  Future<void> _onSent(MessageSent event, Emitter<MessageState> emit) async {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessageEntity(
      time: DateTime.now(),
      text: text,
      image: LocalStorage.user.image,
      isMe: true,
    );

    emit(state.copyWith(messages: [message, ...state.messages]));
    _sendMessage(chatId: _chatId, text: text);
  }

  void _onReceived(MessageReceived event, Emitter<MessageState> emit) {
    emit(state.copyWith(messages: [event.message, ...state.messages]));
  }
}
