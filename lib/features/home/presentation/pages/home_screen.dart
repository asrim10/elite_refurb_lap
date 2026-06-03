import 'package:EliteReurbLap/features/home/presentation/widgets/category_chips.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_header.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_search_bar.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/laptop_product_card.dart';
import 'package:flutter/material.dart';

final List<LaptopProduct> _products = [
  const LaptopProduct(
    name: 'MacBook Pro 13"',
    specs: 'M2, 16GB RAM, 512GB',
    price: '\$1,149',
    condition: 'Excellent',
    conditionColor: Color(0xFF766054),
    conditionBgColor: Color(0x4CFBDCCD),
    imageUrl:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop&auto=format',
  ),
  const LaptopProduct(
    name: 'Dell XPS 13',
    specs: 'i7, 16GB, 1TB SSD',
    price: '\$899',
    condition: 'Good',
    conditionColor: Color(0xFF4B454A),
    conditionBgColor: Color(0xFFE2E2E2),
    imageUrl:
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop&auto=format',
  ),
  const LaptopProduct(
    name: 'Lenovo ThinkPad T14',
    specs: 'Ryzen 7, 32GB RAM',
    price: '\$749',
    condition: 'Fair',
    conditionColor: Color(0xFF4B454A),
    conditionBgColor: Color(0xFFE2E2E2),
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=400&fit=crop&auto=format',
  ),
  const LaptopProduct(
    name: 'HP EliteBook 840',
    specs: 'i5, 16GB, 256GB SSD',
    price: '\$620',
    condition: 'Excellent',
    conditionColor: Color(0xFF766054),
    conditionBgColor: Color(0x4CFBDCCD),
    imageUrl:
        'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=400&h=400&fit=crop&auto=format',
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _selectedBottomNav = 0;

  @override
  Widget build(BuildContext context) {
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
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedBottomNav,
        onTabChanged: (index) => setState(() => _selectedBottomNav = index),
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return LaptopProductCard(product: _products[index]);
      },
    );
  }
}
