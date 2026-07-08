import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/enum.dart';
import '../../../../app/router.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/screen/error_screen.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/component/text_field/common_text_field.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/chat_list_model.dart';
import '../bloc/chat/bloc.dart';
import '../bloc/chat/events.dart';
import '../bloc/chat/state.dart';
import '../widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatBloc(sl<MessageRemoteDataSource>())..add(ChatStarted()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const CommonText(
            text: AppString.inbox,
            fontWeight: .w600,
            fontSize: 24,
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) => switch (state.status) {
            ApiStatus.initial => const SizedBox.shrink(),
            ApiStatus.loading => const CommonLoader(),
            ApiStatus.failure => ErrorScreen(
              onTap: () => context.read<ChatBloc>().add(ChatStarted()),
            ),
            ApiStatus.success => _ChatList(state: state),

            // TODO: Handle this case.
          },
        ),
        bottomNavigationBar: const CommonBottomNavBar(currentIndex: 2),
      ),
    );
  }
}

class _ChatList extends StatefulWidget {
  const _ChatList({required this.state});

  final ChatState state;

  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        context.read<ChatBloc>().add(ChatLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chats = widget.state.chats;

    return Padding(
      padding: .symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          const CommonTextField(
            prefixIcon: Icon(Icons.search),
            hintText: AppString.searchDoctor,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<ChatBloc>().add(ChatRefreshed()),
              child: ListView.builder(
                padding: .only(top: 16.h),
                controller: _scrollController,
                itemCount: chats.length,
                itemBuilder: (_, index) {
                  final ChatModel item = chats[index];
                  return GestureDetector(
                    onTap: () => AppNavigator.toNamed(
                      AppRoutes.message,
                      extra: {
                        'chatId': item.id,
                        'name': item.participant.fullName,
                        'image': item.participant.image,
                      },
                    ),
                    child: ChatListItem(item: item),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
