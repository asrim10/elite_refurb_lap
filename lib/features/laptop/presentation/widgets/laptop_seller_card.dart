import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class LaptopSellerCard extends StatelessWidget {
  final LaptopEntity laptop;
  final String? sellerNameOverride;

  const LaptopSellerCard({super.key, required this.laptop, this.sellerNameOverride});

  @override
  Widget build(BuildContext context) {
    final displayName = sellerNameOverride ?? laptop.sellerName;
    final initial = (displayName?.isNotEmpty == true ? displayName! : 'S')[0].toUpperCase();

    return Container(
      width: double.infinity,
      height: 80,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: const ShapeDecoration(
              color: Colors.black,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                initial,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 21),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      displayName ?? 'Seller',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        const Icon(Icons.star, size: 14, color: Color(0xFF705A4E)),
                        Text(
                          '4.2',
                          style: const TextStyle(
                            color: Color(0xFF1A1C1C),
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.27,
                            letterSpacing: 0.88,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  spacing: 4,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF4B454A)),
                    Text(
                      laptop.location?.address ?? 'Location not specified',
                      style: const TextStyle(
                        color: Color(0xFF4B454A),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 24, color: Colors.black),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
