import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_filter_chips.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/similar_items_section.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_bottom_nav.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = [
    'All Items',
    'Available',
    'Price Drop',
    'Sold',
  ];

  final List<WishlistItem> _wishlistItems = const [
    WishlistItem(
      imageUrl: '',
      title: 'MacBook Pro 13"',
      specs: 'M1 Chip • 8GB • 256GB SSD',
      price: 849,
      originalPrice: 999,
      hasPriceDrop: true,
    ),
    WishlistItem(
      imageUrl: '',
      title: 'Dell XPS 13',
      specs: 'Intel i7 • 16GB • 512GB SSD',
      price: 720,
    ),
  ];

  final List<SimilarItem> _similarItems = const [
    SimilarItem(
      imageUrl: '',
      title: 'HP ProBook 440',
      condition: 'Verified Mint',
      price: 549,
    ),
    SimilarItem(
      imageUrl: '',
      title: 'Asus VivoBook 15',
      condition: 'Light Wear',
      price: 490,
    ),
    SimilarItem(
      imageUrl: '',
      title: 'Surface Laptop 4',
      condition: 'Verified Pristine',
      price: 780,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            WishlistFilterChips(
              filters: _filters,
              selectedIndex: _selectedFilter,
              onFilterChanged: (index) =>
                  setState(() => _selectedFilter = index),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWishlistItems(),
                    SimilarItemsSection(items: _similarItems),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WishlistBottomNav(
        selectedIndex: 2,
        onTabChanged: (index) {
          if (index == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const ShapeDecoration(
        color: Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My Wishlist',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Text(
                  '${_wishlistItems.length} SAVED',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
          const Icon(Icons.more_vert, size: 20, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < _wishlistItems.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            WishlistItemCard(
              item: _wishlistItems[i],
              onChat: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat - Coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              onRemove: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from wishlist'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
