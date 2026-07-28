import 'dart:async';

import 'package:EliteReurbLap/app/app.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_header.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_search_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/laptop_product_card.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/laptop_details_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/state/wishlist_state.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _subscribedToRoute = false;
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData({bool showLoading = true}) {
    ref
        .read(laptopViewModelProvider.notifier)
        .getAllLaptops(
          showLoading: showLoading,
          queryParameters: const {'status': 'available'},
        );
    ref.read(wishlistViewModelProvider.notifier).getMyWishlist();
    ref.read(notificationViewModelProvider.notifier).getNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_subscribedToRoute) {
      _subscribedToRoute = true;
      _routeObserver = ref.read(routeObserverProvider);
      final route = ModalRoute.of(context);
      if (route != null && _routeObserver != null) {
        _routeObserver!.subscribe(this, route);
      }
    }
  }

  @override
  void dispose() {
    if (_subscribedToRoute && _routeObserver != null) {
      _routeObserver!.unsubscribe(this);
    }
    _searchController.dispose();
    super.dispose();
  }

  /// Called when this screen becomes the top-most route after another route pops.
  @override
  void didPopNext() {
    _fetchData(showLoading: false);
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

  /// The banner carousel displayed inside the scrollable list.
  Widget _buildBanner() {
    return const _BannerCarousel(
      banners: ['assets/images/banner1.png', 'assets/images/banner2.png'],
    );
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
      } else if (next.status == WishlistStatus.error &&
          next.errorMessage != null) {
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
            Expanded(child: _buildProductList(laptopState, wishlistIds)),
          ],
        ),
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
          child: CircularProgressIndicator(color: Color(0xFFC4B0A4)),
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
                        .getAllLaptops(
                          queryParameters: const {'status': 'available'},
                        );
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

        final showResultCount = _searchQuery.isNotEmpty;

        return CustomScrollView(
          slivers: [
            // Banner at the top
            SliverToBoxAdapter(
              child: _buildBanner(),
            ),
            // Result count (if search is active)
            if (showResultCount)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 12,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${laptops.length} result${laptops.length == 1 ? '' : 's'}',
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
              ),
            // Product grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.53,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final laptop = laptops[index];
                    final isFavorite =
                        laptop.id != null && wishlistIds.contains(laptop.id);
                    return LaptopProductCard(
                      product: laptop,
                      isFavorite: isFavorite,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LaptopDetailsScreen(laptop: laptop),
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
                  childCount: laptops.length,
                ),
              ),
            ),
          ],
        );
    }
  }
}

/// An auto-scrolling banner carousel with dot indicators.
class _BannerCarousel extends StatefulWidget {
  final List<String> banners;

  const _BannerCarousel({required this.banners});

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: 185,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  return Image.asset(widget.banners[index], fit: BoxFit.cover);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentPage ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? const Color(0xFF9A8174)
                      : const Color(0xFFCDC4CA),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
