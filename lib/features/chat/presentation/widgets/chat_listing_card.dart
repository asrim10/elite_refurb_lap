import 'package:flutter/material.dart';

class ChatListingCard extends StatelessWidget {
  final String title;
  final String price;
  final String? imageUrl;

  const ChatListingCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: Color(0xFFF5F0EC)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFC4B0A4)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: 48,
                    height: 48,
                  )
                : const Center(
                    child: Icon(
                      Icons.laptop_mac_outlined,
                      size: 24,
                      color: Color(0xFFC4B0A4),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF705A4E),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.bookmark_border, size: 24, color: Colors.black),
        ],
      ),
    );
  }
}
