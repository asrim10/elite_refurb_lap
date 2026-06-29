import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Simple data class for a similar recommended item.
class SimilarItem {
  final String imageUrl;
  final String title;
  final String condition;
  final double price;

  const SimilarItem({
    required this.imageUrl,
    required this.title,
    required this.condition,
    required this.price,
  });
}

class SimilarItemsSection extends StatelessWidget {
  final List<SimilarItem> items;

  const SimilarItemsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

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
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return _SimilarCard(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  final SimilarItem item;

  const _SimilarCard({required this.item});

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
          // Image area
          Container(
            height: 144,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
            child: Center(
              child: Container(
                width: 136,
                height: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: const Icon(
                  Icons.laptop_mac_outlined,
                  size: 48,
                  color: Color(0xFFC4B0A4),
                ),
              ),
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
                  item.condition,
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
    );
  }
}

String _formatPrice(double price) {
  final format = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);
  return format.format(price);
}
