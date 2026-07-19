import 'package:flutter/material.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String label;

  const NotificationSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4B454A),
          fontSize: 11,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.88,
        ),
      ),
    );
  }
}
