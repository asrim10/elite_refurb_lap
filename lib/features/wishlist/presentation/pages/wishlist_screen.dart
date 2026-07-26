import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:EliteReurbLap/features/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/laptop_details_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
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

  List<LaptopEntity> _getSimilarLaptops(List<String> wishlistIds, List<LaptopEntity> allLaptops) {
    // Exclude laptops already in the wishlist
    final similar = allLaptops
        .where((laptop) => laptop.id != null && !wishlistIds.contains(laptop.id))
        .toList();
    // Shuffle to get variety, then take up to 8
    similar.shuffle();
    return similar.take(8).toList();
  }

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

  Future<void> _onChatNow(BuildContext context, LaptopEntity laptop) async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final sessionService = ref.read(userSessionServiceProvider);
    final currentUserId = sessionService.getCurrentUserId();

    // Don't allow chatting with yourself
    if (laptop.sellerId != null && laptop.sellerId == currentUserId) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('You cannot chat with yourself'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final sellerName = laptop.sellerName ?? 'the seller';

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.chat_outlined, size: 22, color: Color(0xFF705A4E)),
            SizedBox(width: 10),
            Text(
              'Start Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Start a conversation with $sellerName about\n${laptop.title}?',
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Yes, Chat Now',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D6A3F),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (laptop.id == null || laptop.sellerId == null) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Cannot start chat: missing laptop or seller info'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Get or create conversation
    await ref.read(chatViewModelProvider.notifier).getOrCreateConversationByLaptop(
      laptopId: laptop.id!,
      sellerId: laptop.sellerId!,
      initialMessage: 'Hi, is this available?',
    );

    final chatState = ref.read(chatViewModelProvider);
    final convo = chatState.selectedConversation;

    if (!mounted) return;

    final imageUrl = laptop.images.isNotEmpty ? laptop.images.first : null;

    nav.push(
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          conversationId: convo?.id ?? '',
          otherParticipantName: sellerName,
          otherParticipantImage: laptop.sellerImage,
          isBuyer: true,
          laptopTitle: laptop.title,
          laptopPrice: 'NPR ${laptop.price.toStringAsFixed(0)}',
          laptopImage: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final laptopState = ref.watch(laptopViewModelProvider);
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
                          SimilarItemsSection(
                              isLoading: laptopState.status == LaptopStatus.loading,
                              items: _getSimilarLaptops(
                                wishlistState.laptopIds,
                                laptopState.laptops,
                              ),
                              onItemTap: (laptop) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LaptopDetailsScreen(
                                      laptopId: laptop.id,
                                      laptop: laptop,
                                    ),
                                  ),
                                );
                              },
                            ),
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
              onChat: () => _onChatNow(context, wishlistLaptops[i]),
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
