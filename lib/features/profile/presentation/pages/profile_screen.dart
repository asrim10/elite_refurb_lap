import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/my_listings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    ref.listen(authViewModelProvider, (prev, next) {
      if (prev != null && prev.status == AuthStatus.loading) {
        if (next.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        } else if (next.status == AuthStatus.error && next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Profile Card
              _buildProfileCard(user),
              const SizedBox(height: 20),
              // Menu Options
              _buildMenuSection(),
              const SizedBox(height: 20),
              // Logout Button
              _buildLogoutButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const ShapeDecoration(
          color: Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Color(0xFFCDC4CA),
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const Spacer(),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AuthEntity? user) {
    final initials = _getInitials(user?.fullName ?? 'U');
    final fullName = user?.fullName ?? 'User';
    final email = user?.email ?? 'user@example.com';
    final username = user?.username ?? 'username';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(width: 1, color: Color(0x4CCDC4CA)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C050206),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: ShapeDecoration(
                  color: AppColors.accent,
                  shape: const CircleBorder(),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Edit button overlay
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Full Name
          Text(
            fullName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            email,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          // Username
          Text(
            '@$username',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(width: 1, color: Color(0x4CCDC4CA)),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C050206),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.storefront_outlined,
            title: 'My Listings',
            subtitle: 'Active, sold & draft listings',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const MyListingsScreen(),
              ),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Account Information',
            subtitle: 'Name, email, username',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'My Addresses',
            subtitle: 'Manage saved locations',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Push, email, SMS',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Password, account protection',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            subtitle: 'Saved laptops & accessories',
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.history,
            title: 'Order History',
            subtitle: 'Past purchases & transactions',
            onTap: () {},
          ),

        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: AppColors.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ] else ...[
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textDisabled,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: Color(0xFFF0EAE5),
      ),
    );
  }

  Widget _buildLogoutButton() {
    final isLoading = ref.watch(authViewModelProvider).status == AuthStatus.loading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () => ref.read(authViewModelProvider.notifier).logout(),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout, size: 20),
          label: Text(isLoading ? 'Logging out...' : 'Log Out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.buttonDangerBg,
            side: const BorderSide(
              color: AppColors.borderAccent,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return 'U';
  }
}
