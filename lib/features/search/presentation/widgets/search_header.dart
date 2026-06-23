import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 67,
      padding: const EdgeInsets.only(
        top: 48,
        left: 20,
        right: 20,
        bottom: 35,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMenuIcon(),
          const Text(
            'ELITEREFURBLAP',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.33,
              letterSpacing: -0.72,
            ),
          ),
          const SizedBox(
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
          (index) => Container(
            width: double.infinity,
            height: 2,
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
