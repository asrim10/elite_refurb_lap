import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFE8E0D8),
            ),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: Color(0x996B5A50),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search laptops by brand, spec...',
                style: TextStyle(
                  color: const Color(0xFF6B5A50).withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
