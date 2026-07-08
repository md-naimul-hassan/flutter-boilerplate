import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/di.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/enum.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/component/text_field/common_text_field.dart';
import '../../../../core/utils/extension.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/models/chat_message_model.dart';
import '../bloc/message/bloc.dart';
import '../bloc/message/events.dart';
import '../bloc/message/state.dart';
import '../widgets/chat_bubble_message.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.chatId,
    required this.name,
    required this.image,
  });

  final String chatId;
  final String name;
  final String image;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();
  late final MessageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MessageBloc(sl<MessageRemoteDataSource>())
      ..add(MessageStarted(chatId: widget.chatId, name: widget.name));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _bloc.add(MessageLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _send() {
    _bloc.add(MessageSent(_messageController.text));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 24.sp,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CommonImage(imageSrc: widget.image, size: 48),
                    ),
                  ),
                  12.width,
                  CommonText(text: state.name, fontWeight: .w700, fontSize: 18),
                ],
              ),
            ),
            body: state.status == ApiStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: state.isMoreLoading
                        ? state.messages.length + 1
                        : state.messages.length,
                    itemBuilder: (_, index) {
                      if (index >= state.messages.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final ChatMessageModel message = state.messages[index];
                      return ChatBubbleMessage(
                        image: message.image,
                        time: message.time,
                        text: message.text,
                        isMe: message.isMe,
                        onTap: () {},
                      );
                    },
                  ),
            bottomNavigationBar: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 150),
              child: Padding(
                padding: .only(left: 20.w, right: 20.w, bottom: 24.h),
                child: CommonTextField(
                  controller: _messageController,
                  hintText: AppString.messageHere,
                  borderColor: Colors.white,
                  borderRadius: 8,
                  suffixIcon: GestureDetector(
                    onTap: _send,
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: const Icon(Icons.send),
                    ),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
