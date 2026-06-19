import 'package:flutter/material.dart';

class LaptopDetailsBottomBar extends StatelessWidget {
  final VoidCallback onCallSeller;
  final VoidCallback onChatNow;

  const LaptopDetailsBottomBar({
    super.key,
    required this.onCallSeller,
    required this.onChatNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 11, left: 20, right: 20, bottom: 8),
      decoration: const ShapeDecoration(
        color: Color(0xFFF5F0EC),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x19CDC4CA)),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 30,
            offset: Offset(0, -10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          spacing: 16,
          children: [
            // Call Seller
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: onCallSeller,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Call Seller',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
            // Chat Now
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onChatNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Chat Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.90,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.51,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
