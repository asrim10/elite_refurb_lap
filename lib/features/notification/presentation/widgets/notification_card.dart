import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeAgo;
  final bool isUnread;
  final Color avatarColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isUnread = false,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: isUnread ? Colors.white : const Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isUnread
                ? const Color(0xFFCDC4CA)
                : Colors.black.withValues(alpha: 0),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: isUnread
            ? const [
                BoxShadow(
                  color: Color(0x0C050206),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar circle
          Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: avatarColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
                side: avatarColor == const Color(0xFFEEEEEE)
                    ? const BorderSide(width: 1, color: Color(0xFFCDC4CA))
                    : BorderSide.none,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row + unread dot
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const ShapeDecoration(
                            color: Colors.black,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subtitle
                SizedBox(
                  width: 350,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF4B454A),
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Time
                SizedBox(
                  width: 350,
                  child: Text(
                    timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF848383),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Wrap read items with an Opacity wrapper (matching the Figma)
    if (!isUnread) {
      return Opacity(opacity: 0.80, child: card);
    }
    return card;
  }
}
