import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/pages/wishlist_screen.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/view_model/wishlist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final user = authState.authEntity;
    final displayName = user?.fullName ?? 'Guest';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    final greeting = _greeting();
    final wishlistCount = wishlistState.laptopIds.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + Greeting
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Greeting Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WELCOME BACK',
                    style: TextStyle(
                      color: Color(0xFF4B454A),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '$greeting, $displayName \u{1F44B}',
                    style: const TextStyle(
                      color: Color(0xFF1A1C1C),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              // Wishlist heart
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WishlistScreen(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    const Icon(
                      Icons.favorite_outline,
                      size: 24,
                      color: Color(0xFF1A1C1C),
                    ),
                    if (wishlistCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFD32F2F),
                            shape: CircleBorder(),
                          ),
                          child: Center(
                            child: Text(
                              wishlistCount > 9 ? '9+' : '$wishlistCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Notification Bell
              Stack(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: Color(0xFF1A1C1C),
                  ),
                  Positioned(
                    right: -3,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: const Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
