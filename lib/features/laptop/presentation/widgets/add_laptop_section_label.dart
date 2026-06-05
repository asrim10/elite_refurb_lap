import 'package:flutter/material.dart';

class AddLaptopSectionLabel extends StatelessWidget {
  final String label;

  const AddLaptopSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4B454A),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.27,
          letterSpacing: 0.88,
        ),
      ),
    );
  }
}
