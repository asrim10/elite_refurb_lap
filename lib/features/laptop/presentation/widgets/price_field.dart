import 'package:flutter/material.dart';

class PriceField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? Function(String?)? validator;
  const PriceField({
    super.key,
    required this.controller,
    this.label,
    this.validator,
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
          decoration: ShapeDecoration(
            color: const Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Stack(
            children: [
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                validator: validator,
                style: const TextStyle(
                  color: Color(0xFF1A1C1C),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                    left: 48,
                    top: 15,
                    bottom: 15,
                    right: 16,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    'Rs',
                    style: TextStyle(
                      color: const Color(0xFF4B454A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
