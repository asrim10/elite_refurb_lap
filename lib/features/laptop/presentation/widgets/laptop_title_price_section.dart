import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class LaptopTitlePriceSection extends StatelessWidget {
  final LaptopEntity laptop;

  const LaptopTitlePriceSection({super.key, required this.laptop});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price
        Text(
          priceFormat.format(laptop.price),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.22,
          ),
        ),
        const SizedBox(height: 4),
        // Title
        Text(
          laptop.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.21,
            letterSpacing: -0.56,
          ),
        ),
        const SizedBox(height: 4),
        // Subtitle
        Text(
          '${laptop.brand} ${laptop.modelName}',
          style: const TextStyle(
            color: Color(0xFF4B454A),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.38,
          ),
        ),
        const SizedBox(height: 12),
        // Badges
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _outlinedBadge('Verified', bgColor: const Color(0xFFE8E0D8)),
            _outlinedBadge(laptop.condition.toUpperCase()),
          ],
        ),
      ],
    );
  }

  Widget _outlinedBadge(String label, {Color bgColor = const Color(0xFFF5F0EC)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0x4CCDC4CA)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6B5A50),
          fontSize: 11,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 1.27,
          letterSpacing: 0.88,
        ),
      ),
    );
  }
}
