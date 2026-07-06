import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/constants/app_string.dart';
import '../../../../app/router.dart';
import '../../../../core/component/bottom_nav_bar/common_bottom_bar.dart';
import '../../../../core/component/other_widgets/common_loader.dart';
import '../../../../core/component/screen/error_screen.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/component/text_field/common_text_field.dart';
import '../../../../core/utils/enum.dart';
import '../../data/model/chat_list_model.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar
      appBar: AppBar(
        centerTitle: true,
        title: const CommonText(
          text: AppString.inbox,
          fontWeight: .w600,
          fontSize: 24,
        ),
      ),

      /// Body
      body: GetBuilder<ChatController>(
        init: ChatController(), // ensure created once
        builder: (controller) => switch (controller.status) {
          /// Loading
          Status.loading => const CommonLoader(),

          /// Error
          Status.error => ErrorScreen(onTap: controller.getChats),

          /// Completed
          Status.completed => Padding(
            padding: .symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                /// Search bar
                CommonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppString.searchDoctor,
                ),

                /// Chat list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshChats,
                    child: ListView.builder(
                      padding: .only(top: 16.h),
                      controller: controller.scrollController,
                      itemCount: controller.chats.length,
                      itemBuilder: (_, index) {
                        final ChatModel item = controller.chats[index];

                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.message,
                            parameters: {
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
          ),
        },
      ),

      /// Bottom nav
      bottomNavigationBar: const CommonBottomNavBar(currentIndex: 2),
    );
  }
}
