import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/enum.dart';
import '../../../../../core/storage/storage_services.dart';
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
    on<MessageClosed>(_onClosed);
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

  Future<void> _onClosed(
    MessageClosed event,
    Emitter<MessageState> emit,
  ) async {
    _chatId = event.chatId;
    _remote.stopListenNewMessages(event.chatId);
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
    try {
      if (initial) {
        emit(state.copyWith(status: ApiStatus.loading, messages: []));
      }

      final newMessages = await _remote.fetchMessages(
        chatId: _chatId,
        page: _page,
      );

      _page++;
      emit(
        state.copyWith(
          status: ApiStatus.success,
          messages: [...state.messages, ...newMessages],
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ApiStatus.failure));
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
