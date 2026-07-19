import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class SellerLocationSection extends StatelessWidget {
  final LaptopLocationEntity? location;

  const SellerLocationSection({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            Text(
              location?.address ?? 'Baneshwor, Kathmandu',
              style: const TextStyle(
                color: Color(0xFF7C757A),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.38,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 140,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFE2E2E2),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x4CCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: 0.80, child: Container(color: Colors.white)),
              Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  color: Colors.black.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF705A4E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
