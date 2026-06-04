import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
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
    final user = authState.authEntity;
    final displayName = user?.fullName ?? 'Guest';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    final greeting = _greeting();

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
    );
  }
}
