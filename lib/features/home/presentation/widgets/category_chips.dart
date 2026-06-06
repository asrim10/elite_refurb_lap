import 'package:flutter/material.dart';

final List<String> _categories = [
  'All',
  'MacBook',
  'Dell',
  'Lenovo',
  'HP',
  'Asus',
];

class CategoryChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;

  const CategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategoryChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: ShapeDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected ? Colors.black : const Color(0xFFC4B0A4),
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              child: Text(
                _categories[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : const Color(0xFF6B5A50),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.88,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
