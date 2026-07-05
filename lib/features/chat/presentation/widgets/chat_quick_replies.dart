import 'package:flutter/material.dart';

class ChatQuickReplies extends StatelessWidget {
  final List<String> replies;
  final ValueChanged<String> onTap;

  const ChatQuickReplies({
    super.key,
    required this.replies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: replies.map((text) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onTap(text),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F0EC),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFC4B0A4),
                      ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3B3B3B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
