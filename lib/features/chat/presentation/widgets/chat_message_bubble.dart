import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String currentUserId;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  bool get _isMine => message.senderId == currentUserId;

  String _formatTime() {
    if (message.createdAt == null) return '';
    return DateFormat('h:mm a').format(message.createdAt!);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.78;

    if (_isMine) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const ShapeDecoration(
                  color: AppColors.bubbleMineBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: AppColors.bubbleMineFg,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(),
                    style: const TextStyle(
                      color: Color(0xFF4B454A),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    message.readAt != null ? Icons.done_all : Icons.done,
                    size: 12,
                    color: message.readAt != null
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF4B454A),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const ShapeDecoration(
                  color: AppColors.bubbleTheirsBg,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0x4CC4B0A4),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                _formatTime(),
                style: const TextStyle(
                  color: Color(0xFF4B454A),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
