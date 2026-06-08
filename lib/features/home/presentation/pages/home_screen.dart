import 'package:EliteReurbLap/features/home/presentation/widgets/category_chips.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_header.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_search_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/laptop_product_card.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategory = 0;
  int _selectedBottomNav = 0;

  @override
  void initState() {
    super.initState();
    // Fetch laptops when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(laptopViewModelProvider.notifier).getAllLaptops();
    });
  }

  @override
  Widget build(BuildContext context) {
    final laptopState = ref.watch(laptopViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const HomeSearchBar(),
            const SizedBox(height: 8),
            CategoryChips(
              selectedIndex: _selectedCategory,
              onCategoryChanged: (index) =>
                  setState(() => _selectedCategory = index),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildProductList(laptopState)),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedBottomNav,
        onTabChanged: (index) {
          if (index == 2) {
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

  Widget _buildProductList(LaptopState laptopState) {
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
        final laptops = laptopState.laptops;
        if (laptops.isEmpty) {
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
            return LaptopProductCard(product: laptops[index]);
          },
        );
    }
  }
}
