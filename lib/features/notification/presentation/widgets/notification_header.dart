import 'package:flutter/material.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback? onMarkAllRead;

  const NotificationHeader({super.key, this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const ShapeDecoration(
        color: Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
        ),
      ),
      child: Row(
        children: [
          const Spacer(),
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMarkAllRead,
            child: const Text(
              'Mark all read',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.88,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
