import 'package:flutter/material.dart';

class LaptopDescriptionSection extends StatefulWidget {
  final String description;

  const LaptopDescriptionSection({super.key, required this.description});

  @override
  State<LaptopDescriptionSection> createState() => _LaptopDescriptionSectionState();
}

class _LaptopDescriptionSectionState extends State<LaptopDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.description;
    final isLong = description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'DESCRIPTION',
            style: TextStyle(
              color: Color(0xFF9A8174),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.88,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLong && !_expanded
                    ? '${description.substring(0, 150)}...'
                    : description,
                style: const TextStyle(
                  color: Color(0xFF4B454A),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.60,
                ),
              ),
              if (isLong)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded ? 'Show less' : 'Read more',
                      style: const TextStyle(
                        color: Color(0xFF9A8174),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
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
