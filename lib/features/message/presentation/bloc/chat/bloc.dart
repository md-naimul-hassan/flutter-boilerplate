import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/enum.dart';
import 'events.dart';
import 'state.dart';
import '../../../data/datasources/remote_data_source.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRemoteDataSource _remote;
  int _page = 1;

  ChatBloc(this._remote) : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatLoadMore>(_onLoadMore);
    on<ChatRefreshed>(_onRefreshed);
    on<ChatListUpdated>(_onListUpdated);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    _remote.listenChatListUpdates((chats) => add(ChatListUpdated(chats)));
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
    try {
      if (initial) emit(state.copyWith(status: ApiStatus.loading));

      final newChats = await _remote.fetchChats(_page);

      _page++;
      emit(
        state.copyWith(
          status: ApiStatus.success,
          chats: [...state.chats, ...newChats],
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ApiStatus.failure));
    }
  }
}
