import 'package:flutter/material.dart';

class WishlistFilterChips extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  const WishlistFilterChips({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isActive = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index < filters.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onFilterChanged(index),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: ShapeDecoration(
                  color: isActive ? const Color(0xFF9A8174) : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: isActive
                        ? BorderSide.none
                        : const BorderSide(width: 1, color: Color(0xFFC4B0A4)),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF6B5A50),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                    letterSpacing: 0.55,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
