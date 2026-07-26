import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaptopProductCard extends StatelessWidget {
  final LaptopEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const LaptopProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  String get _formattedSpecs {
    final storageStr = product.storage >= 1000
        ? '${(product.storage / 1000).toStringAsFixed(0)}TB'
        : '${product.storage}GB';
    return '${product.processor}, ${product.ram}GB RAM, $storageStr ${product.storageType}';
  }

  String get _formattedPrice {
    final format = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);
    return format.format(product.price);
  }

  String get _conditionLabel {
    if (product.condition.isEmpty) return 'Good';
    return product.condition[0].toUpperCase() + product.condition.substring(1);
  }

  Color get _conditionTextColor {
    switch (product.condition.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF766054);
      case 'good':
        return const Color(0xFF4B454A);
      case 'fair':
      default:
        return const Color(0xFF4B454A);
    }
  }

  Color get _conditionBgColor {
    switch (product.condition.toLowerCase()) {
      case 'excellent':
        return const Color(0x4CFBDCCD);
      case 'good':
        return const Color(0xFFE2E2E2);
      case 'fair':
      default:
        return const Color(0xFFE2E2E2);
    }
  }

  String get _imageUrl =>
      product.images.isNotEmpty ? ApiEndpoints.getImageUrl(product.images.first) : '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0x4CE8E0D8),
            ),
            borderRadius: BorderRadius.circular(20),
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
            // Image Section — fills remaining space via Expanded, never overflows
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Color(0xFFF5F0EC)),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: _imageUrl.isNotEmpty
                            ? Image.network(
                                _imageUrl,
                                fit: BoxFit.contain,
                                width: 130,
                                height: 130,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  final total = loadingProgress.expectedTotalBytes;
                                  final progress = total != null
                                      ? loadingProgress.cumulativeBytesLoaded / total
                                      : null;
                                  return Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 2.5,
                                        color: const Color(0xFFC4B0A4),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.laptop_mac,
                                    size: 60,
                                    color: Color(0xFFC4B0A4),
                                  );
                                },
                              )
                            : const Icon(
                                Icons.laptop_mac,
                                size: 60,
                                color: Color(0xFFC4B0A4),
                              ),
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: onFavorite,
                        child: Container(
                          width: 42,
                          height: 42,
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
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 22,
                            color: isFavorite
                                ? const Color(0xFFD32F2F)
                                : const Color(0xFF6B5A50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Details Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
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
                        label: _conditionLabel,
                        bgColor: _conditionBgColor,
                        textColor: _conditionTextColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Product Name
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Specs
                  Text(
                    _formattedSpecs,
                    style: const TextStyle(
                      color: Color(0xFF9A8174),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    _formattedPrice,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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

  Widget _buildTag({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
