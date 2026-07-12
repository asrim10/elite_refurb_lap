import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final MessageEntity message;
  final String currentUserId;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final String? otherUserImage;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.otherUserImage,
  });

  bool get _isMine {
    final isMine = message.senderId == currentUserId;
    debugPrint('🔍 ChatMessageBubble: senderId="${message.senderId}" currentUserId="$currentUserId" isMine=$isMine content="${message.content}"');
    return isMine;
  }

  String _formatTime() {
    if (message.createdAt == null) return '';
    return DateFormat('h:mm a').format(message.createdAt!.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInGroup ? 6 : 2,
        bottom: isLastInGroup ? 4 : 1,
      ),
      child: _isMine ? _buildSentBubble(maxWidth) : _buildReceivedBubble(maxWidth),
    );
  }

  Widget _buildSentBubble(double maxWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bubbleMineBg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: const Radius.circular(18),
                bottomRight: Radius.circular(isLastInGroup ? 4 : 18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.content,
                  style: const TextStyle(
                    color: AppColors.bubbleMineFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(),
                      style: const TextStyle(
                        color: AppColors.white50,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      message.readAt != null ? Icons.done_all : Icons.done,
                      size: 11,
                      color: message.readAt != null
                          ? const Color(0xFF4CAF50)
                          : AppColors.white50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedBubble(double maxWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Avatar for the first message in a group
        if (isFirstInGroup && otherUserImage != null)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(
                ApiEndpoints.getImageUrl(otherUserImage!),
              ),
            ),
          )
        else if (isFirstInGroup)
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: SizedBox(width: 26, height: 26),
          )
        else
          const SizedBox(width: 32),

        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isLastInGroup ? 4 : 18),
                bottomRight: const Radius.circular(18),
              ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(),
                    style: const TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
