import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

/// Simple data class for a wishlist item.
class WishlistItem {
  final String imageUrl;
  final String title;
  final String specs;
  final double price;

  const WishlistItem({
    required this.imageUrl,
    required this.title,
    required this.specs,
    required this.price,
  });

  factory WishlistItem.fromLaptop(LaptopEntity laptop) {
    final storageStr = laptop.storage >= 1000
        ? '${(laptop.storage / 1000).toStringAsFixed(0)}TB'
        : '${laptop.storage}GB';
    return WishlistItem(
      imageUrl: laptop.images.isNotEmpty ? laptop.images.first : '',
      title: laptop.title,
      specs: '${laptop.processor}, ${laptop.ram}GB RAM, $storageStr ${laptop.storageType}',
      price: laptop.price,
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback? onChat;
  final VoidCallback? onRemove;

  const WishlistItemCard({
    super.key,
    required this.item,
    this.onChat,
    this.onRemove,
  });

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
            color: Color(0x4CC4B0A4),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Container(
                      width: 96,
                      height: 96,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF9F9F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(
                              ApiEndpoints.getImageUrl(item.imageUrl),
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
                                return const Center(
                                  child: Icon(
                                    Icons.laptop_mac_outlined,
                                    size: 40,
                                    color: Color(0xFFC4B0A4),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.laptop_mac_outlined,
                                size: 40,
                                color: Color(0xFFC4B0A4),
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Title, specs, price
                    Expanded(
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
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              item.specs,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF766054),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                _formatPrice(item.price),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Buttons
                const SizedBox(height: 8),
                _ActionButtons(onChat: onChat, onRemove: onRemove),
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

/// Action buttons for the wishlist item card.
class _ActionButtons extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onRemove;

  const _ActionButtons({this.onChat, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: _ChatButton(onPressed: onChat),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: _RemoveButton(onPressed: onRemove),
        ),
      ],
    );
  }
}

class _ChatButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ChatButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 18, color: Colors.black),
          SizedBox(width: 8),
          Text(
            'CHAT',
            textAlign: TextAlign.center,
            style: TextStyle(
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
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _RemoveButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF3F3F4),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.close, size: 18, color: Color(0xFF4B454A)),
          SizedBox(width: 8),
          Text(
            'REMOVE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4B454A),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.27,
              letterSpacing: 0.88,
            ),
          ),
        ],
      ),
    );
  }
}
