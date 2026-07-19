import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/laptop_details_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/profile/presentation/pages/profile_screen.dart';
import 'package:EliteReurbLap/features/search/domain/search_filter.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_category_chips.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_featured_product_card.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_filter_sheet.dart';

import 'package:EliteReurbLap/features/search/presentation/widgets/search_small_product_card.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _SortOption {
  newestFirst,
  oldestFirst,
  priceLowToHigh,
  priceHighToLow,
  nameAToZ,
  nameZToA,
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  int _selectedCategory = 0;
  int _selectedBottomNav = 1;
  SearchFilter _currentFilter = const SearchFilter();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _SortOption _sortOption = _SortOption.newestFirst;

  String get _sortLabel {
    switch (_sortOption) {
      case _SortOption.newestFirst:
        return 'Newest';
      case _SortOption.oldestFirst:
        return 'Oldest';
      case _SortOption.priceLowToHigh:
        return 'Price: Low';
      case _SortOption.priceHighToLow:
        return 'Price: High';
      case _SortOption.nameAToZ:
        return 'Name: A-Z';
      case _SortOption.nameZToA:
        return 'Name: Z-A';
    }
  }

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

  void _showFilterSheet() {
    showModalBottomSheet<SearchFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x4C050206),
      builder: (_) => SearchFilterSheet(
        currentFilter: _currentFilter,
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _currentFilter = result;
        });
        _applyFilters();
      }
    });
  }

  void _applyFilters() {
    // Refetch with filter parameters
    final params = _currentFilter.toQueryParams();
    final filteredParams = <String, dynamic>{};
    filteredParams.addAll(params);

    // Add search query if present
    if (_searchQuery.isNotEmpty) {
      filteredParams['search'] = _searchQuery;
    }

    ref.read(laptopViewModelProvider.notifier).getAllLaptops(
          queryParameters: filteredParams.isNotEmpty ? filteredParams : null,
        );
  }

  /// Filters laptops locally based on the selected category chip.
  List<LaptopEntity> _getFilteredLaptops(List<LaptopEntity> laptops) {
    if (laptops.isEmpty) return laptops;

    // Apply category filter
    if (_selectedCategory == 0) return laptops; // ALL LAPTOPS

    final categoryLabel = SearchCategoryChips.categories[_selectedCategory];
    return laptops.where((laptop) {
      final title = laptop.title.toLowerCase();
      final brand = laptop.brand.toLowerCase();
      switch (categoryLabel) {
        case 'MACBOOK':
          return brand.contains('apple') || title.contains('macbook');
        case 'THINKPAD':
          return brand.contains('lenovo') || title.contains('thinkpad');
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final laptopState = ref.watch(laptopViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final wishlistIds = wishlistState.laptopIds;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<_SortOption>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _sortLabel,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.sort,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
              ],
            ),
            onSelected: (option) {
              setState(() => _sortOption = option);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            elevation: 2,
            offset: const Offset(0, 40),
            itemBuilder: (_) => [
              _buildSortItem(_SortOption.newestFirst, Icons.new_releases_outlined),
              _buildSortItem(_SortOption.oldestFirst, Icons.history),
              _buildSortItem(_SortOption.priceLowToHigh, Icons.trending_up),
              _buildSortItem(_SortOption.priceHighToLow, Icons.trending_down),
              _buildSortItem(_SortOption.nameAToZ, Icons.sort_by_alpha),
              _buildSortItem(_SortOption.nameZToA, Icons.sort_by_alpha),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed top section: Search + Chips
            Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 8),
                SearchCategoryChips(
                  selectedIndex: _selectedCategory,
                  onCategoryChanged: (index) =>
                      setState(() => _selectedCategory = index),
                  onFilterTap: _showFilterSheet,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Scrollable product content
            Expanded(
              child: _buildContent(laptopState, wishlistIds),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedBottomNav,
        onTabChanged: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddLaptopScreen(),
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

  Widget _buildContent(LaptopState laptopState, List<String> wishlistIds) {
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
        return _buildProductGrid(laptopState.laptops, wishlistIds);
    }
  }

  Widget _buildProductGrid(List<LaptopEntity> allLaptops, List<String> wishlistIds) {
    final filtered = _getFilteredLaptops(allLaptops);

    // Apply search query filter (client-side)
    final searched = _searchQuery.isEmpty
        ? filtered
        : filtered.where((laptop) {
            final query = _searchQuery.toLowerCase();
            return laptop.title.toLowerCase().contains(query) ||
                laptop.brand.toLowerCase().contains(query) ||
                laptop.processor.toLowerCase().contains(query) ||
                laptop.modelName.toLowerCase().contains(query);
          }).toList();

    // Apply sorting
    final sorted = List<LaptopEntity>.from(searched);
    _applySorting(sorted);

    // Apply filter sheet filters only when the user has explicitly set them
    final finalResults = _currentFilter.hasActiveFilters
        ? sorted.where((laptop) {
            if (_currentFilter.laptopType != null &&
                !laptop.title.toLowerCase().contains(_currentFilter.laptopType!.toLowerCase()) &&
                !laptop.brand.toLowerCase().contains(_currentFilter.laptopType!.toLowerCase())) {
              return false;
            }
            if (_currentFilter.processor != null &&
                !laptop.processor.toLowerCase().contains(_currentFilter.processor!.toLowerCase())) {
              return false;
            }
            if (_currentFilter.ram != null) {
              final ramStr = laptop.ram.toString();
              if (!ramStr.contains(_currentFilter.ram!.replaceAll('GB', '').trim())) {
                return false;
              }
            }
            if (_currentFilter.storage != null) {
              final storageStr = laptop.storage >= 1000
                  ? '${(laptop.storage / 1000).toStringAsFixed(0)}TB'
                  : '${laptop.storage}GB';
              if (!storageStr.contains(_currentFilter.storage!)) {
                return false;
              }
            }
            if (laptop.price < _currentFilter.minPrice ||
                laptop.price > _currentFilter.maxPrice) {
              return false;
            }
            return true;
          }).toList()
        : sorted;

    if (finalResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.laptop_mac_outlined,
                size: 64,
                color: const Color(0xFFC4B0A4),
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty
                    ? 'No laptops found for "$_searchQuery"'
                    : 'No laptops available',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF9A8174),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try adjusting your search or filters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFC4B0A4),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 44),
      child: Column(
        children: [
          // Result count header
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  '${finalResults.length} result${finalResults.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (_currentFilter.hasActiveFilters) ...[                    
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentFilter = const SearchFilter();
                      });
                      ref.read(laptopViewModelProvider.notifier)
                          .getAllLaptops();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE4CCBE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Filtered',
                            style: TextStyle(
                              color: Color(0xFF332219),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.close,
                            size: 10,
                            color: Color(0xFF332219),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Featured product (first result)
          if (finalResults.isNotEmpty) ...[
            SearchFeaturedProductCard.fromLaptop(
              finalResults[0],
              isFavorite: finalResults[0].id != null &&
                  wishlistIds.contains(finalResults[0].id),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        LaptopDetailsScreen(laptop: finalResults[0]),
                  ),
                );
              },
              onWishlistTap: () {
                _toggleWishlist(finalResults[0], wishlistIds);
              },
            ),
            const SizedBox(height: 16),
          ],
          // Row of small product cards (next 2 results)
          if (finalResults.length > 1)
            Row(
              children: [
                Expanded(
                  child: SearchSmallProductCard.fromLaptop(
                    finalResults[1],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              LaptopDetailsScreen(laptop: finalResults[1]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                if (finalResults.length > 2)
                  Expanded(
                    child: SearchSmallProductCard.fromLaptop(
                      finalResults[2],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LaptopDetailsScreen(laptop: finalResults[2]),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Expanded(child: SizedBox.shrink()),
              ],
            ),
          // Remaining results as a list
          if (finalResults.length > 3) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE8E0D8)),
            const SizedBox(height: 16),
            ...List.generate(finalResults.length - 3, (index) {
              final laptop = finalResults[index + 3];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildResultRow(laptop, wishlistIds),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(LaptopEntity laptop, List<String> wishlistIds) {
    final isFavorite =
        laptop.id != null && wishlistIds.contains(laptop.id);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LaptopDetailsScreen(laptop: laptop),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 6,
              offset: Offset(0, 2),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 72,
                height: 72,
                color: const Color(0xFFF2F1EF),
                child: laptop.images.isNotEmpty
                    ? Image.network(
                        ApiEndpoints.getImageUrl(laptop.images.first),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.laptop_mac,
                            size: 32,
                            color: Color(0xFFC4B0A4),
                          );
                        },
                      )
                    : const Icon(
                        Icons.laptop_mac,
                        size: 32,
                        color: Color(0xFFC4B0A4),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    laptop.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${laptop.processor} • ${laptop.ram}GB RAM',
                    style: const TextStyle(
                      color: Color(0xFF9A8174),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${(laptop.price).toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Favorite button
            GestureDetector(
              onTap: () => _toggleWishlist(laptop, wishlistIds),
              child: Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFFD1D5DB),
                    ),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: isFavorite
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleWishlist(LaptopEntity laptop, List<String> wishlistIds) {
    if (laptop.id == null) return;
    if (wishlistIds.contains(laptop.id)) {
      ref.read(wishlistViewModelProvider.notifier).removeLaptop(laptop.id!);
    } else {
      ref.read(wishlistViewModelProvider.notifier).addLaptop(laptop.id!);
    }
  }

  void _applySorting(List<LaptopEntity> laptops) {
    switch (_sortOption) {
      case _SortOption.newestFirst:
        laptops.sort((a, b) {
          final aTime = a.createdAt ?? DateTime(2000);
          final bTime = b.createdAt ?? DateTime(2000);
          return bTime.compareTo(aTime);
        });
      case _SortOption.oldestFirst:
        laptops.sort((a, b) {
          final aTime = a.createdAt ?? DateTime(2000);
          final bTime = b.createdAt ?? DateTime(2000);
          return aTime.compareTo(bTime);
        });
      case _SortOption.priceLowToHigh:
        laptops.sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceHighToLow:
        laptops.sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.nameAToZ:
        laptops.sort((a, b) => a.title.compareTo(b.title));
      case _SortOption.nameZToA:
        laptops.sort((a, b) => b.title.compareTo(a.title));
    }
  }

  PopupMenuItem<_SortOption> _buildSortItem(
    _SortOption option,
    IconData icon,
  ) {
    final isActive = _sortOption == option;
    return PopupMenuItem<_SortOption>(
      value: option,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive ? const Color(0xFF8C6751) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          Text(
            _labelForOption(option),
            style: TextStyle(
              color: isActive ? Colors.black : const Color(0xFF374151),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          if (isActive) ...[
            const Spacer(),
            const Icon(
              Icons.check,
              size: 16,
              color: Color(0xFF8C6751),
            ),
          ],
        ],
      ),
    );
  }

  String _labelForOption(_SortOption option) {
    switch (option) {
      case _SortOption.newestFirst:
        return 'Newest First';
      case _SortOption.oldestFirst:
        return 'Oldest First';
      case _SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case _SortOption.priceHighToLow:
        return 'Price: High to Low';
      case _SortOption.nameAToZ:
        return 'Name: A to Z';
      case _SortOption.nameZToA:
        return 'Name: Z to A';
    }
  }
}
