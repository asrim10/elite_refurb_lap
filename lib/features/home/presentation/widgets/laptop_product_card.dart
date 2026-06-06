import 'package:flutter/material.dart';

class LaptopProduct {
  final String name;
  final String specs;
  final String price;
  final String condition;
  final Color conditionColor;
  final Color conditionBgColor;
  final String imageUrl;

  const LaptopProduct({
    required this.name,
    required this.specs,
    required this.price,
    required this.condition,
    required this.conditionColor,
    required this.conditionBgColor,
    required this.imageUrl,
  });
}

class LaptopProductCard extends StatelessWidget {
  final LaptopProduct product;

  const LaptopProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CE8E0D8),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C050206),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            width: double.infinity,
            height: 180,
            decoration: const BoxDecoration(color: Color(0xFFF5F0EC)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
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
                        return const Center(
                          child: Icon(
                            Icons.laptop_mac,
                            size: 48,
                            color: Color(0xFFC4B0A4),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.80),
                      shape: const CircleBorder(),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Color(0xFF6B5A50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Details Section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Wrap(
                  spacing: 4,
                  runSpacing: 0,
                  children: [
                    _buildTag(
                      label: 'Verified',
                      bgColor: const Color(0xFFF5F0EC),
                      textColor: const Color(0xFF6B5A50),
                    ),
                    _buildTag(
                      label: product.condition,
                      bgColor: product.conditionBgColor,
                      textColor: product.conditionColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                // Specs
                Text(
                  product.specs,
                  style: const TextStyle(
                    color: Color(0xFF9A8174),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                // Price
                Text(
                  product.price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 9,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
