import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storeage/storage_services.dart';
import '../../../../../core/utils/enum.dart';
import '../../../data/models/chat_message_model.dart';
import './events.dart';
import './state.dart';
import '../../../data/datasources/remote_data_source.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRemoteDataSource _remote;
  String _chatId = '';
  int _page = 1;

  MessageBloc(this._remote) : super(const MessageState()) {
    on<MessageStarted>(_onStarted);
    on<MessageLoadMore>(_onLoadMore);
    on<MessageSent>(_onSent);
    on<MessageReceived>(_onReceived);
  }

  Future<void> _onStarted(
    MessageStarted event,
    Emitter<MessageState> emit,
  ) async {
    _chatId = event.chatId;
    emit(state.copyWith(name: event.name));
    _remote.listenNewMessages(
      event.chatId,
      (message) => add(MessageReceived(message)),
    );
    await _fetch(emit, initial: true);
  }

  Future<void> _onLoadMore(
    MessageLoadMore event,
    Emitter<MessageState> emit,
  ) async {
    if (state.isMoreLoading || state.status == Status.loading) return;
    emit(state.copyWith(isMoreLoading: true));
    await _fetch(emit);
    emit(state.copyWith(isMoreLoading: false));
  }

  Future<void> _fetch(
    Emitter<MessageState> emit, {
    bool initial = false,
  }) async {
    try {
      if (initial) emit(state.copyWith(status: Status.loading, messages: []));

      final newMessages = await _remote.fetchMessages(
        chatId: _chatId,
        page: _page,
      );

      _page++;
      emit(
        state.copyWith(
          status: Status.completed,
          messages: [...state.messages, ...newMessages],
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> _onSent(MessageSent event, Emitter<MessageState> emit) async {
    final text = event.text.trim();
    if (text.isEmpty) return;

    final message = ChatMessageModel(
      time: DateTime.now(),
      text: text,
      image: LocalStorage.user.image,
      isMe: true,
    );

    emit(state.copyWith(messages: [message, ...state.messages]));
    _remote.sendMessage(chatId: _chatId, text: text);
  }

  void _onReceived(MessageReceived event, Emitter<MessageState> emit) {
    emit(state.copyWith(messages: [event.message, ...state.messages]));
  }
}
