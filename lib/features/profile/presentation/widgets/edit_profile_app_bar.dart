import 'package:flutter/material.dart';

class EditProfileAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const EditProfileAppBar({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        height: 76,
        padding: const EdgeInsets.only(left: 8, right: 20, top: 32),
        decoration: const ShapeDecoration(
          color: Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0x4CCDC4CA)),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            ),
            const Spacer(),
            const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.44,
              ),
            ),
            const Spacer(),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
