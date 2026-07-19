import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_filter_chips.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/similar_items_section.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/widgets/wishlist_bottom_nav.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = [
    'All Items',
    'Available',
    'Price Drop',
    'Sold',
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
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wishlistViewModelProvider.notifier).getMyWishlist();
      ref.read(laptopViewModelProvider.notifier).getAllLaptops();
    });
  }

  List<LaptopEntity> _getWishlistLaptops(List<String> wishlistIds) {
    final laptopState = ref.watch(laptopViewModelProvider);
    if (wishlistIds.isEmpty) return [];
    return laptopState.laptops
        .where((laptop) => laptop.id != null && wishlistIds.contains(laptop.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistLaptops = _getWishlistLaptops(wishlistState.laptopIds);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(wishlistLaptops.length),
            WishlistFilterChips(
              filters: _filters,
              selectedIndex: _selectedFilter,
              onFilterChanged: (index) =>
                  setState(() => _selectedFilter = index),
            ),
            Expanded(
              child: wishlistState.status == WishlistStatus.loading &&
                      wishlistLaptops.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC4B0A4),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildWishlistItems(wishlistLaptops),
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

  Widget _buildAppBar(int savedCount) {
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
                  '$savedCount SAVED',
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

  Widget _buildWishlistItems(List<LaptopEntity> wishlistLaptops) {
    if (wishlistLaptops.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 64,
              color: Color(0xFFC4B0A4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(
                color: Color(0xFF9A8174),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart icon on laptops to save them here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFC4B0A4),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < wishlistLaptops.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            WishlistItemCard(
              item: WishlistItem.fromLaptop(wishlistLaptops[i]),
              onChat: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat - Coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              onRemove: () {
                final laptopId = wishlistLaptops[i].id;
                if (laptopId != null) {
                  ref
                      .read(wishlistViewModelProvider.notifier)
                      .removeLaptop(laptopId);
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
