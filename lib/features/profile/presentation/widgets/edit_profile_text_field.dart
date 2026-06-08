import 'package:flutter/material.dart';

class EditProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?)? validator;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF848383),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.88,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 52,
          decoration: ShapeDecoration(
            color: enabled ? Colors.white : const Color(0xFFF0EAE5),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFCDC4CA),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            validator: validator,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              filled: false,
            ),
          ),
        ),
      ],
    );
  }
}
