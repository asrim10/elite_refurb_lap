import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.only(
        left: 44.75,
        right: 44.78,
        bottom: 3,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CCDC4CA),
          ),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C050206),
            blurRadius: 20,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            isActive: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          _buildNavItem(
            icon: Icons.search,
            label: 'Search',
            isActive: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
          _buildNavItem(
            icon: Icons.add_circle_outline,
            label: 'Post',
            isActive: selectedIndex == 2,
            onTap: () => onTabChanged(2),
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            isActive: selectedIndex == 3,
            onTap: () => onTabChanged(3),
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: selectedIndex == 4,
            onTap: () => onTabChanged(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 24,
            color: isActive ? Colors.black : const Color(0xFF848383),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black : const Color(0xFF848383),
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
