import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../core/utils/extension.dart';
import '../../data/model/chat_list_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatModel item;

  const ChatListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final message = item.latestMessage.message;

    return Padding(
      padding: .symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        children: [
          Row(
            children: [
              CommonImage(
                imageSrc: item.participant.image,
                size: 56,
                borderRadius: 500,
              ),
              12.height,

              /// Name + message
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    /// Name
                    CommonText(
                      text: item.participant.fullName,
                      fontWeight: .w600,
                      fontSize: 16,
                    ),

                    4.height,

                    /// Last message preview
                    CommonText(text: message, fontSize: 13, color: Colors.grey),
                  ],
                ),
              ),

              /// Optional time
              CommonText(
                text: _formatTime(item.latestMessage.createdAt),
                fontSize: 11,
                color: Colors.grey,
              ),
            ],
          ),

          10.height,

          /// Divider
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// Format message time
  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
