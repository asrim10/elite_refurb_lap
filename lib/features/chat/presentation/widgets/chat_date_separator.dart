import 'package:flutter/material.dart';

class ChatDateSeparator extends StatelessWidget {
  final String label;

  const ChatDateSeparator({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: ShapeDecoration(
            color: const Color(0xFFEEEEEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF848383),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.27,
              letterSpacing: 0.88,
            ),
          ),
        ),
      ),
    );
  }
}
