import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:flutter/material.dart';

class SearchFeaturedProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String specs;
  final String price;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const SearchFeaturedProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.specs,
    required this.price,
    this.onTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 2),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 176,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF2F1EF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accent,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.laptop_mac,
                      size: 48,
                      color: AppColors.textDisabled,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Title + Verified badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        specs,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildVerifiedBadge(),
              ],
            ),
            const SizedBox(height: 12),
            // Price + Wishlist row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
                _buildWishlistButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Text(
        'VERIFIED',
        style: TextStyle(
          color: Color(0xFF777777),
          fontSize: 10,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _buildWishlistButton() {
    return GestureDetector(
      onTap: onWishlistTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: const Icon(
          Icons.favorite_border,
          size: 18,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}
