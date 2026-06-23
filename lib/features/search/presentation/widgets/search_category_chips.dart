import 'package:flutter/material.dart';

class SearchCategoryChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;

  static const List<String> categories = [
    'ALL LAPTOPS',
    'MACBOOK',
    'THINKPAD',
  ];

  const SearchCategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1, // +1 for filter button
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return _buildFilterButton();
          }
          return _buildCategoryChip(
            label: categories[index],
            isSelected: selectedIndex == index,
            onTap: () => onCategoryChanged(index),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFE4CCBE) : Colors.white,
          shape: RoundedRectangleBorder(
            side: isSelected
                ? BorderSide.none
                : const BorderSide(width: 1, color: Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF332219)
                  : const Color(0xFF374151),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: 1.10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 40,
      height: 36,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: const Icon(
        Icons.tune,
        size: 18,
        color: Color(0xFF374151),
      ),
    );
  }
}
