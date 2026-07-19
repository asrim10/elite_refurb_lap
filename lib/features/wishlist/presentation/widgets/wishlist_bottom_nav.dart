import 'package:flutter/material.dart';

class WishlistBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const WishlistBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 32),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF3F4F6)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'HOME',
            isActive: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _NavItem(
            icon: Icons.search,
            label: 'SEARCH',
            isActive: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
          _NavItem(
            icon: Icons.favorite_outlined,
            label: 'WISHLIST',
            isActive: selectedIndex == 2,
            onTap: () => onTabChanged(2),
          ),
          _NavItem(
            icon: Icons.chat_bubble_outline,
            label: 'CHAT',
            isActive: selectedIndex == 3,
            onTap: () => onTabChanged(3),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'PROFILE',
            isActive: selectedIndex == 4,
            onTap: () => onTabChanged(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? Colors.black : const Color(0xFFA0A0A0),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : const Color(0xFFA0A0A0),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: 1,
            ),
          ),
          if (isActive)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 4),
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
            ),
        ],
      ),
    );
  }
}
