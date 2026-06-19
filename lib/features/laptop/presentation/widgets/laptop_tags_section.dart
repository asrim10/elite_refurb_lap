import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class LaptopTagsSection extends StatelessWidget {
  final LaptopEntity laptop;

  const LaptopTagsSection({super.key, required this.laptop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'TAGS',
            style: TextStyle(
              color: Color(0xFF9A8174),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.88,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: laptop.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFCDC4CA),
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Text(
                '#$tag',
                style: const TextStyle(
                  color: Color(0xFF4B454A),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
