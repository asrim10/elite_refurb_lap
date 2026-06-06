import 'package:flutter/material.dart';

class AddLaptopTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool expands;

  const AddLaptopTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: Color(0xFF4B454A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          width: double.infinity,
          constraints: expands ? const BoxConstraints(minHeight: 100) : null,
          decoration: ShapeDecoration(
            color: const Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: expands ? 4 : 1,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
