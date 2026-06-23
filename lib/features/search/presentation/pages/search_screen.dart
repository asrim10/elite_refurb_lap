import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/profile/presentation/pages/profile_screen.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_bar_widget.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_category_chips.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_featured_product_card.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_header.dart';
import 'package:EliteReurbLap/features/search/presentation/widgets/search_small_product_card.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedCategory = 0;
  int _selectedBottomNav = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Collapsible header section
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 200,
              collapsedHeight: 80,
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    const SearchHeader(),
                    const SizedBox(height: 8),
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: (value) {
                        // TODO: implement search filtering
                      },
                    ),
                    const SizedBox(height: 4),
                    SearchCategoryChips(
                      selectedIndex: _selectedCategory,
                      onCategoryChanged: (index) =>
                          setState(() => _selectedCategory = index),
                    ),
                  ],
                ),
              ),
            ),
            // Product content
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SearchFeaturedProductCard(
                    imageUrl: 'https://placehold.co/368x176',
                    title: 'MacBook Pro 16" M2 Max',
                    specs: '32GB RAM • 1TB SSD • Space Black',
                    price: '\$2,499',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SearchSmallProductCard(
                          title: 'XPS 13 Plus',
                          specs: '16GB • 512GB',
                          imageUrl: 'https://placehold.co/168x128',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SearchSmallProductCard(
                          title: 'Razer Blade 14',
                          specs: 'RTX 4070 • 1TB',
                          imageUrl: 'https://placehold.co/168x128',
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedBottomNav,
        onTabChanged: (index) {
          if (index == 0) {
            // Navigate back to Home
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
}
