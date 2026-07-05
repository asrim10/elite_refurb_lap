import 'package:flutter/material.dart';

class ChatFilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterChanged;

  static const List<String> filters = [
    'ALL MESSAGES',
    'UNREAD',
    'BUYING',
    'SELLING',
  ];

  const ChatFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isActive = index == selectedIndex;
            return GestureDetector(
              onTap: () => onFilterChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: isActive ? const Color(0xFF705A4E) : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: isActive
                        ? BorderSide.none
                        : const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF4B454A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
