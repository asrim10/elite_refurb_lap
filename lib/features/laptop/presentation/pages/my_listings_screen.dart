import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ListingFilter { active, sold, drafts }

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  ListingFilter _selectedFilter = ListingFilter.active;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(laptopViewModelProvider.notifier).getMyListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(laptopViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(state.laptops),
            Expanded(child: _buildContent(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddLaptopScreen(),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
          const Text(
            'My Listings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.21,
              letterSpacing: -0.56,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: const Icon(
              Icons.more_horiz,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(List<LaptopEntity> laptops) {
    final activeCount = laptops.where((l) => l.status == 'available').length;
    final soldCount = laptops.where((l) => l.status == 'sold').length;
    final draftsCount = laptops.where((l) => l.status == 'draft').length;

    return Container(
      width: 440,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 48,
        children: [
          _buildFilterChip(
            label: 'Active ($activeCount)',
            isSelected: _selectedFilter == ListingFilter.active,
          ),
          _buildFilterChip(
            label: 'Sold ($soldCount)',
            isSelected: _selectedFilter == ListingFilter.sold,
          ),
          _buildFilterChip(
            label: 'Drafts ($draftsCount)',
            isSelected: _selectedFilter == ListingFilter.drafts,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = switch (label.startsWith('Active')) {
            true => ListingFilter.active,
            false => label.startsWith('Sold') ? ListingFilter.sold : ListingFilter.drafts,
          };
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF9A8174) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: isSelected
                ? BorderSide.none
                : const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4B454A),
                fontSize: 11,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.27,
                letterSpacing: 0.88,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(LaptopState state) {
    switch (state.status) {
      case LaptopStatus.loading:
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9A8174),
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
                  state.errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4B454A),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    ref.read(laptopViewModelProvider.notifier).getMyListings();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      case LaptopStatus.initial:
      case LaptopStatus.loaded:
      case LaptopStatus.created:
      case LaptopStatus.updated:
      case LaptopStatus.deleted:
        final filteredLaptops = _filteredLaptops(state.laptops);
        if (filteredLaptops.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFilter == ListingFilter.active
                      ? 'No active listings yet'
                      : _selectedFilter == ListingFilter.sold
                          ? 'No sold items yet'
                          : 'No drafts yet',
                  style: const TextStyle(
                    color: Color(0xFF4B454A),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start by posting your first laptop!',
                  style: TextStyle(
                    color: Color(0xFF9A8174),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          itemCount: filteredLaptops.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _ListingCard(
              laptop: filteredLaptops[index],
              onEdit: () {
                // Navigate to edit screen with laptop data
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddLaptopScreen(),
                  ),
                );
              },
              onDelete: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Listing'),
                    content: const Text(
                      'Are you sure you want to delete this listing?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && filteredLaptops[index].id != null) {
                  ref
                      .read(laptopViewModelProvider.notifier)
                      .deleteLaptop(filteredLaptops[index].id!);
                }
              },
            );
          },
        );
    }
  }

  List<LaptopEntity> _filteredLaptops(List<LaptopEntity> laptops) {
    return laptops.where((laptop) {
      return switch (_selectedFilter) {
        ListingFilter.active => laptop.status == 'available',
        ListingFilter.sold => laptop.status == 'sold',
        ListingFilter.drafts => laptop.status == 'draft',
      };
    }).toList();
  }
}

class _ListingCard extends StatelessWidget {
  final LaptopEntity laptop;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ListingCard({
    required this.laptop,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = laptop.images.isNotEmpty
        ? ApiEndpoints.getImageUrl(laptop.images.first)
        : 'https://placehold.co/350x201/E8E0D8/9A8174?text=No+Image';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CC4B0A4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Color(0xFFF5F0EC)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: const Color(0xFFE8E0D8),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF9A8174),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: const Color(0xFFE8E0D8),
                          child: const Center(
                            child: Icon(
                              Icons.laptop_mac,
                              size: 48,
                              color: Color(0xFF9A8174),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  left: 12,
                  top: 12,
                  child: _buildStatusBadge(laptop.status),
                ),
              ],
            ),
          ),
          // Details Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                // Title & Price Row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        laptop.title,
                        style: const TextStyle(
                          color: Color(0xFF1A1C1C),
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${laptop.price.toStringAsFixed(laptop.price == laptop.price.roundToDouble() ? 0 : 2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                    ),
                  ],
                ),
                // Specs
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${laptop.ram}GB RAM • ${laptop.storage}GB ${laptop.storageType}${laptop.processor.isNotEmpty ? ' • ${laptop.processor}' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF4B454A),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                // Footer Row
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Stats
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          _buildStat(icon: Icons.visibility_outlined, value: '0'),
                          _buildStat(icon: Icons.favorite_border, value: '0'),
                        ],
                      ),
                      // Actions
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          _buildEditButton(),
                          _buildDeleteButton(),
                        ],
                      ),],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(
        color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: ShapeDecoration(
              color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFF57C00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          Text(
            isActive ? 'ACTIVE' : status.toUpperCase(),
            style: TextStyle(
              color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFF57C00),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required IconData icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF4B454A)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4B454A),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.only(
          top: 8.50,
          left: 16,
          right: 16,
          bottom: 9.50,
        ),
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'EDIT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFCDC4CA),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Icon(
          Icons.delete_outline,
          size: 18,
          color: Color(0xFF4B454A),
        ),
      ),
    );
  }
}
