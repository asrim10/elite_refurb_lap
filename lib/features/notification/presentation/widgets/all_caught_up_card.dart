import 'package:flutter/material.dart';

class AllCaughtUpCard extends StatelessWidget {
  const AllCaughtUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 2,
            color: Color(0xFFCDC4CA),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Column(
        children: [
          SizedBox(height: 8),
          Text(
            'You\'re all caught up for now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF848383),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
