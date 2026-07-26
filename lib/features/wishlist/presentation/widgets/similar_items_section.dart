import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class SimilarItemsSection extends StatelessWidget {
  final List<LaptopEntity> items;
  final void Function(LaptopEntity item)? onItemTap;
  final bool isLoading;

  const SimilarItemsSection({
    super.key,
    required this.items,
    this.onItemTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading && items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.only(top: 24),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Color(0x19C4B0A4),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SIMILAR TO YOUR WISHLIST',
                  style: TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 20, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 270,
            child: isLoading
                ? const _ShimmerList()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return _SimilarCard(
                        item: items[index],
                        onTap: onItemTap != null
                            ? () => onItemTap!(items[index])
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  final LaptopEntity item;
  final VoidCallback? onTap;

  const _SimilarCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.images.isNotEmpty ? item.images.first : '';
    return Container(
      width: 170,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CC4B0A4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              Container(
                height: 144,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
                child: Center(
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          ApiEndpoints.getImageUrl(imageUrl),
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFC4B0A4),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const _LaptopPlaceholder();
                          },
                        )
                      : const _LaptopPlaceholder(),
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1A1C1C),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCondition(item.condition),
                      style: const TextStyle(
                        color: Color(0xFF766054),
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPrice(item.price),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class _ShimmerList extends StatefulWidget {
  const _ShimmerList();

  @override
  State<_ShimmerList> createState() => _ShimmerListState();
}

class _ShimmerListState extends State<_ShimmerList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: child,
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => const _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CC4B0A4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer image area
          Container(
            height: 144,
            decoration: const BoxDecoration(color: Color(0xFFE8E0DA)),
          ),
          // Shimmer details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E0DA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E0DA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E0DA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LaptopPlaceholder extends StatelessWidget {
  const _LaptopPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: const Icon(
        Icons.laptop_mac_outlined,
        size: 48,
        color: Color(0xFFC4B0A4),
      ),
    );
  }
}

String _formatCondition(String condition) {
  switch (condition.toLowerCase()) {
    case 'mint':
      return 'Verified Mint';
    case 'excellent':
      return 'Verified Excellent';
    case 'good':
      return 'Light Wear';
    case 'fair':
      return 'Moderate Wear';
    default:
      return condition;
  }
}

String _formatPrice(double price) {
  final format = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);
  return format.format(price);
}
