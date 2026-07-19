import 'package:flutter/material.dart';

class SellerStatsRow extends StatelessWidget {
  const SellerStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('RESPONSE RATE', '98%')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('COMPLETED SALES', '450+')),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x4CCDC4CA)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7C757A),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.27,
              letterSpacing: 0.88,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}
