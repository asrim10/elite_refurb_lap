import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

/// Simple data class for a wishlist item.
class WishlistItem {
  final String imageUrl;
  final String title;
  final String specs;
  final double price;
  final double? originalPrice;
  final bool hasPriceDrop;

  const WishlistItem({
    required this.imageUrl,
    required this.title,
    required this.specs,
    required this.price,
    this.originalPrice,
    this.hasPriceDrop = false,
  });

  factory WishlistItem.fromLaptop(LaptopEntity laptop) {
    final hasPriceDrop = laptop.originalPrice != null && laptop.originalPrice! > laptop.price;
    final storageStr = laptop.storage >= 1000
        ? '${(laptop.storage / 1000).toStringAsFixed(0)}TB'
        : '${laptop.storage}GB';
    return WishlistItem(
      imageUrl: laptop.images.isNotEmpty ? laptop.images.first : '',
      title: laptop.title,
      specs: '${laptop.processor}, ${laptop.ram}GB RAM, $storageStr ${laptop.storageType}',
      price: laptop.price,
      originalPrice: laptop.originalPrice,
      hasPriceDrop: hasPriceDrop,
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
    final hasPriceDrop = item.hasPriceDrop;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: hasPriceDrop
                ? const Color(0xFF9A8174)
                : const Color(0x4CC4B0A4),
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
                // Price Drop Badge
                if (hasPriceDrop) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_downward_rounded,
                        size: 14,
                        color: Color(0xFF9A8174),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'PRICE DROP!',
                        style: TextStyle(
                          color: Color(0xFF9A8174),
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                          letterSpacing: 0.55,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                // Image + Info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
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
                      child: const Center(
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
                                style: TextStyle(
                                  color: hasPriceDrop
                                      ? const Color(0xFF9A8174)
                                      : Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1.22,
                                ),
                              ),
                              if (item.originalPrice != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _formatPrice(item.originalPrice!),
                                  style: const TextStyle(
                                    color: Color(0xFF4B454A),
                                    fontSize: 13,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Buttons
                const SizedBox(height: 8),
                if (hasPriceDrop)
                  _PriceDropButtons(onChat: onChat, onRemove: onRemove)
                else
                  _NormalButtons(onChat: onChat, onRemove: onRemove),
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

class _PriceDropButtons extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onRemove;

  const _PriceDropButtons({this.onChat, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(child: _ChatButton(onPressed: onChat)),
          const SizedBox(width: 8),
          Expanded(child: _RemoveButton(onPressed: onRemove)),
        ],
      ),
    );
  }
}

/// Full-width stacked CHAT + REMOVE buttons for normal item.
class _NormalButtons extends StatelessWidget {
  final VoidCallback? onChat;
  final VoidCallback? onRemove;

  const _NormalButtons({this.onChat, this.onRemove});

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
