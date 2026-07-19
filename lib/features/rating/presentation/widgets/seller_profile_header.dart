import 'package:flutter/material.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';

class SellerProfileHeader extends StatelessWidget {
  final String sellerName;
  final String? sellerImageUrl;
  final VoidCallback? onRateSeller;

  const SellerProfileHeader({
    super.key,
    required this.sellerName,
    this.sellerImageUrl,
    this.onRateSeller,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S';
    final hasImage = sellerImageUrl != null && sellerImageUrl!.isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: const Color(0xFFE8E8E8),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0x4CCDC4CA),
                    ),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: hasImage ? null : Colors.black,
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(
                              ApiEndpoints.getImageUrl(sellerImageUrl!),
                            ),
                            fit: BoxFit.fill,
                          )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: hasImage
                      ? null
                      : Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 28,
                  height: 28,
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            sellerName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF3F3F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFF705A4E)),
                    const SizedBox(width: 4),
                    Text(
                      '4.2 (128)',
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
              ),
              const SizedBox(width: 8),
              Text(
                '•',
                style: const TextStyle(
                  color: Color(0xFF7C757A),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Active since 2021',
                style: const TextStyle(
                  color: Color(0xFF7C757A),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                  letterSpacing: 0.88,
                ),
              ),
            ],
          ),
          if (onRateSeller != null) ...[  
            const SizedBox(height: 12),
            SizedBox(
              height: 32,
              child: TextButton.icon(
                onPressed: onRateSeller,
                icon: const Icon(Icons.star_outline, size: 16, color: Color(0xFF705A4E)),
                label: const Text(
                  'Rate Seller',
                  style: TextStyle(
                    color: Color(0xFF705A4E),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0x4CCDC4CA)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
