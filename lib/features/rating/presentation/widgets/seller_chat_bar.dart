import 'package:flutter/material.dart';

class SellerChatBar extends StatelessWidget {
  final VoidCallback? onChatNow;

  const SellerChatBar({super.key, this.onChatNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        shape: const RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x19CDC4CA)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: onChatNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      'CHAT NOW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.27,
                        letterSpacing: 0.88,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 64,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Call seller
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Icon(
                Icons.phone_outlined,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
