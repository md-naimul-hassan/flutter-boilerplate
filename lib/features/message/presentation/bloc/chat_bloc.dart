import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/enum.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/get_chats.dart';
import '../../domain/usecases/listen_chat_list_updates.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required this._getChats, required this._listenChatListUpdates})
    : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatLoadMore>(_onLoadMore);
    on<ChatRefreshed>(_onRefreshed);
    on<ChatListUpdated>(_onListUpdated);
  }

  final GetChats _getChats;
  final ListenChatListUpdates _listenChatListUpdates;
  int _page = 1;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    _listenChatListUpdates((chats) => add(ChatListUpdated(chats)));
    await _fetch(emit, initial: true);
  }

  Future<void> _onLoadMore(ChatLoadMore event, Emitter<ChatState> emit) async {
    if (state.isMoreLoading || state.status == ApiStatus.loading) return;
    emit(state.copyWith(isMoreLoading: true));
    await _fetch(emit);
    emit(state.copyWith(isMoreLoading: false));
  }

  Future<void> _onRefreshed(
    ChatRefreshed event,
    Emitter<ChatState> emit,
  ) async {
    _page = 1;
    emit(state.copyWith(chats: []));
    await _fetch(emit, initial: true);
  }

  void _onListUpdated(ChatListUpdated event, Emitter<ChatState> emit) {
    _page = 1;
    emit(state.copyWith(status: ApiStatus.success, chats: event.chats));
  }

  Future<void> _fetch(Emitter<ChatState> emit, {bool initial = false}) async {
    if (initial) emit(state.copyWith(status: ApiStatus.loading));

    final result = await _getChats(_page);

    switch (result) {
      case Success(:final data):
        _page++;
        emit(
          state.copyWith(
            status: ApiStatus.success,
            chats: [...state.chats, ...data],
          ),
        );
      case Failed():
        emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
