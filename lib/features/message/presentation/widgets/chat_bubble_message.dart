import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/component/image/common_image.dart';
import '../../../../core/component/text/common_text.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../core/utils/extension.dart';


class ChatBubbleMessage extends StatelessWidget {
  final DateTime time;
  final String text;
  final String image;
  final bool isMe;
  final VoidCallback onTap;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    required this.text,
    required this.image,
    required this.isMe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? AppColors.primaryColor : AppColors.white;

    final textColor = isMe ? AppColors.white : AppColors.black;

    return Padding(
      padding: .symmetric(vertical: 6.h, horizontal: 12.w),
      child: Row(
        mainAxisAlignment: isMe ? .end : .start,
        crossAxisAlignment: .end,
        children: [
          /// Avatar (only for others)
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: CommonImage(imageSrc: image, size: 36),
            ),

          /// Bubble
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: .symmetric(horizontal: 14.w, vertical: 10.h),
                constraints: BoxConstraints(maxWidth: Get.width * .7),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: .circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    /// Message text
                    CommonText(text: text, color: textColor),

                    4.height,

                    /// Time
                    Align(
                      alignment: .bottomRight,
                      child: CommonText(
                        text:
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                        fontSize: 10,
                        color: textColor.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
