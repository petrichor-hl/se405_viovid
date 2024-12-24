import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:viovid_app/features/noti_center/dtos/user_notification.dart';

class NewCommentNoti extends StatelessWidget {
  const NewCommentNoti({
    super.key,
    required this.notification,
  });

  final UserNotification notification;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 65,
            height: 65,
            child: CachedNetworkImage(
              imageUrl: notification.params['commentOwnerAvatar'],
              fit: BoxFit.cover,
              // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
              fadeInDuration: const Duration(milliseconds: 400),
              // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
              fadeOutDuration: const Duration(milliseconds: 800),
              placeholder: (context, url) => const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                // textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: '${notification.params['commentOwnerName']}',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold, // Áp dụng style riêng cho tên
                        color: Colors
                            .yellow, // Bạn có thể thay đổi màu sắc nếu muốn
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' vừa bình luận bài viết của bạn.', // Phần text không cần style đặc biệt
                    ),
                  ],
                ),
              ),
              const Gap(4),
              Text(
                "\"${notification.params['content']}\"",
                style: const TextStyle(
                  color: Colors.white70,
                  // fontSize: 16,
                ),
              ),
              const Gap(10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DateFormat('dd-MM-yyyy HH:mm')
                      .format(notification.createdDateTime),
                  style: const TextStyle(
                    color: Colors.white70,
                    // fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
