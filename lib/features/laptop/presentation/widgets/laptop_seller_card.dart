import 'package:flutter/material.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/rating/presentation/pages/seller_profile_screen.dart';

class LaptopSellerCard extends StatelessWidget {
  final LaptopEntity laptop;
  final String? sellerNameOverride;
  final String? sellerImageUrl;
  final double averageRating;
  final int totalRatings;
  final VoidCallback? onTapSeller;

  const LaptopSellerCard({
    super.key,
    required this.laptop,
    this.sellerNameOverride,
    this.sellerImageUrl,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    this.onTapSeller,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = sellerNameOverride ?? laptop.sellerName;
    final initial =
        (displayName?.isNotEmpty == true ? displayName! : 'S')[0].toUpperCase();
    final imageUrl = sellerImageUrl ?? laptop.sellerImage;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (onTapSeller != null) {
          onTapSeller!();
        } else if (laptop.sellerId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SellerProfileScreen(
                sellerId: laptop.sellerId!,
                sellerName: displayName ?? 'Seller',
                sellerImageUrl: sellerImageUrl ?? laptop.sellerImage,
                location: laptop.location,
              ),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
        child: Row(
          children: [
            const SizedBox(width: 16),
            // Avatar
            ClipOval(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: hasImage ? null : Colors.black,
                  image: hasImage
                      ? DecorationImage(
                          image: NetworkImage(
                            ApiEndpoints.getImageUrl(imageUrl),
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasImage
                    ? null
                    : Center(
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
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFF705A4E),
                          ),
                          Text(
                            averageRating > 0
                                ? averageRating.toStringAsFixed(1)
                                : '-',
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
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF4B454A),
                      ),
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
      ),
    );
  }
}
