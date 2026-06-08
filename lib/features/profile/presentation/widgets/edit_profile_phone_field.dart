import 'package:flutter/material.dart';

class EditProfilePhoneField extends StatelessWidget {
  final TextEditingController controller;

  const EditProfilePhoneField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Phone Number',
              style: TextStyle(
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
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFCDC4CA),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Text(
                  '+977',
                  style: TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24,
                color: const Color(0xFFCDC4CA),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: Color(0xFF1A1C1C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    filled: false,
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
