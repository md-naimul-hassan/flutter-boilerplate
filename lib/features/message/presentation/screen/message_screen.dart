import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/component/text_field/common_text_field.dart';
import '../../../../core/utils/extension.dart';
import '../../data/model/chat_message_model.dart';
import '../controller/message_controller.dart';
import '../widgets/chat_bubble_message.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageController>(
      init: MessageController(), // create once
      initState: (_) {
        final controller = MessageController.instance;
        final params = Get.parameters;
        controller.chatId = params['chatId'] ?? '';
        controller.name = params['name'] ?? '';
        controller.listenMessage(controller.chatId);
        controller.getMessages();
      },
      builder: (controller) {
        return Scaffold(
          /// AppBar
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 24.sp,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CommonImage(
                      imageSrc: Get.parameters['image'] ?? '',
                      size: 48,
                    ),
                  ),
                ),
                12.width,
                CommonText(
                  text: controller.name,
                  fontWeight: .w700,
                  fontSize: 18,
                ),
              ],
            ),
          ),

          /// Body
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  controller: controller.scrollController,
                  itemCount: controller.isMoreLoading
                      ? controller.messages.length + 1
                      : controller.messages.length,
                  itemBuilder: (_, index) {
                    if (index >= controller.messages.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final ChatMessageModel message = controller.messages[index];

                    return ChatBubbleMessage(
                      image: message.image,
                      time: message.time,
                      text: message.text,
                      isMe: message.isMe,
                      onTap: () {},
                    );
                  },
                ),

          /// Bottom input
          bottomNavigationBar: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 150),
            child: Padding(
              padding: .only(left: 20.w, right: 20.w, bottom: 24.h),
              child: CommonTextField(
                controller: controller.messageController,
                hintText: AppString.messageHere,
                borderColor: Colors.white,
                borderRadius: 8,
                suffixIcon: GestureDetector(
                  onTap: controller.sendMessage,
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: const Icon(Icons.send),
                  ),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
        );
      },
    );
  }
}
