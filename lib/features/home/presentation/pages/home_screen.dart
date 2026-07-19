import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_header.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_search_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/laptop_product_card.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/laptop_details_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:EliteReurbLap/features/profile/presentation/pages/profile_screen.dart';
import 'package:EliteReurbLap/features/search/presentation/pages/search_screen.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedBottomNav = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(laptopViewModelProvider.notifier).getAllLaptops();
      ref.read(wishlistViewModelProvider.notifier).getMyWishlist();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters laptops locally based on the search query.
  List<LaptopEntity> _getFilteredLaptops(List<LaptopEntity> laptops) {
    if (_searchQuery.isEmpty) return laptops;
    final query = _searchQuery.toLowerCase();
    return laptops.where((laptop) {
      return laptop.title.toLowerCase().contains(query) ||
          laptop.brand.toLowerCase().contains(query) ||
          laptop.processor.toLowerCase().contains(query) ||
          laptop.modelName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final laptopState = ref.watch(laptopViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistIds = wishlistState.laptopIds;

    ref.listen<WishlistState>(wishlistViewModelProvider, (prev, next) {
      if (prev?.status == next.status) return;
      if (next.status == WishlistStatus.laptopAdded) {
        _showSnackBar('Added to wishlist');
      } else if (next.status == WishlistStatus.laptopRemoved) {
        _showSnackBar('Removed from wishlist');
      } else if (next.status == WishlistStatus.error && next.errorMessage != null) {
        _showSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            HomeSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: 12),
            // Result count when search is active
            if (_searchQuery.isNotEmpty && (laptopState.status == LaptopStatus.loaded ||
                laptopState.status == LaptopStatus.created ||
                laptopState.status == LaptopStatus.updated ||
                laptopState.status == LaptopStatus.deleted))
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      '${_getFilteredLaptops(laptopState.laptops).length} result${_getFilteredLaptops(laptopState.laptops).length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildProductList(laptopState, wishlistIds)),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedBottomNav,
        onTabChanged: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SearchScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddLaptopScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ChatListScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );
          } else {
            setState(() => _selectedBottomNav = index);
          }
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildProductList(LaptopState laptopState, List<String> wishlistIds) {
    switch (laptopState.status) {
      case LaptopStatus.initial:
      case LaptopStatus.loading:
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC4B0A4),
          ),
        );
      case LaptopStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Color(0xFF9A8174),
                ),
                const SizedBox(height: 16),
                Text(
                  laptopState.errorMessage ?? 'Failed to load laptops',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9A8174),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    ref
                        .read(laptopViewModelProvider.notifier)
                        .getAllLaptops();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      case LaptopStatus.loaded:
      case LaptopStatus.created:
      case LaptopStatus.updated:
      case LaptopStatus.deleted:
        final laptops = _getFilteredLaptops(laptopState.laptops);
        if (laptops.isEmpty) {
          if (_searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 64,
                    color: Color(0xFFC4B0A4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No laptops found for "$_searchQuery"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9A8174),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try a different search term',
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
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.laptop_mac_outlined,
                  size: 64,
                  color: Color(0xFFC4B0A4),
                ),
                SizedBox(height: 16),
                Text(
                  'No listings yet',
                  style: TextStyle(
                    color: Color(0xFF9A8174),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Be the first to add a laptop listing!',
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
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: laptops.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final laptop = laptops[index];
            final isFavorite =
                laptop.id != null && wishlistIds.contains(laptop.id);
            return LaptopProductCard(
              product: laptop,
              isFavorite: isFavorite,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LaptopDetailsScreen(laptop: laptop),
                  ),
                );
              },
              onFavorite: () {
                if (laptop.id != null) {
                  if (isFavorite) {
                    ref
                        .read(wishlistViewModelProvider.notifier)
                        .removeLaptop(laptop.id!);
                  } else {
                    ref
                        .read(wishlistViewModelProvider.notifier)
                        .addLaptop(laptop.id!);
                  }
                }
              },
            );
          },
        );
    }
  }
}
