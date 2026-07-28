import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/seller_listing_card.dart';

class SellerListingsSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<LaptopEntity>? listings;
  final VoidCallback? onRetry;
  final void Function(LaptopEntity laptop) onListingTap;
  final VoidCallback? onViewAll;

  const SellerListingsSection({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.listings,
    this.onRetry,
    required this.onListingTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Listings',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            if (listings != null && listings!.length > 3)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'VIEW ALL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF705A4E),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.27,
                    letterSpacing: 0.88,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: CircularProgressIndicator(color: Color(0xFF705A4E)),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFFCDC4CA),
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load listings',
                style: const TextStyle(
                  color: Color(0xFF9A8174),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF9A8174),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFF705A4E), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tap to retry',
                    style: TextStyle(
                      color: Color(0xFF705A4E),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final items = listings;

    if (items == null || items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.store_mall_directory_outlined,
                size: 40,
                color: Color(0xFFCDC4CA),
              ),
              SizedBox(height: 12),
              Text(
                'No listings yet',
                style: TextStyle(color: Color(0xFF9A8174), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final displayItems = items.take(3).toList();

    return Column(
      children: displayItems
          .map(
            (laptop) => Padding(
              padding: EdgeInsets.only(
                bottom: laptop == displayItems.last ? 0 : 12,
              ),
              child: SellerListingCard(
                laptop: laptop,
                onTap: () => onListingTap(laptop),
              ),
            ),
          )
          .toList(),
    );
  }
}
