import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class LaptopSpecsCard extends StatelessWidget {
  final LaptopEntity laptop;

  const LaptopSpecsCard({super.key, required this.laptop});

  @override
  Widget build(BuildContext context) {
    final storageStr = laptop.storage >= 1000
        ? '${(laptop.storage / 1000).toStringAsFixed(0)}TB'
        : '${laptop.storage}GB';

    final specs = [
      _SpecItem(icon: Icons.memory_outlined, label: 'Processor', value: laptop.processor),
      _SpecItem(icon: Icons.storage_outlined, label: 'RAM', value: '${laptop.ram}GB'),
      _SpecItem(icon: Icons.disc_full_outlined, label: 'Storage', value: '$storageStr ${laptop.storageType}'),
      _SpecItem(
        icon: Icons.monitor_outlined,
        label: 'Display',
        value: '${laptop.displaySize.toStringAsFixed(1)}"${laptop.displayResolution != null ? ' ${laptop.displayResolution}' : ''}',
      ),
      if (laptop.gpu != null && laptop.gpu!.isNotEmpty)
        _SpecItem(icon: Icons.videogame_asset_outlined, label: 'GPU', value: laptop.gpu!),
      if (laptop.operatingSystem != null && laptop.operatingSystem!.isNotEmpty)
        _SpecItem(icon: Icons.desktop_windows_outlined, label: 'OS', value: laptop.operatingSystem!),
      if (laptop.batteryLife != null)
        _SpecItem(icon: Icons.battery_charging_full_outlined, label: 'Battery', value: '${laptop.batteryLife!.toStringAsFixed(1)} hrs'),
      if (laptop.weight != null)
        _SpecItem(icon: Icons.fitness_center_outlined, label: 'Weight', value: '${laptop.weight!.toStringAsFixed(1)} kg'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'KEY SPECIFICATIONS',
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
              children: [
                for (int i = 0; i < specs.length; i++) ...[
                  if (i > 0)
                    Container(
                      height: 1,
                      color: const Color(0xFFF0EAE5),
                      margin: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  _buildRow(specs[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(_SpecItem spec) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F0EC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Icon(spec.icon, size: 18, color: const Color(0xFF6B5A50)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spec.label,
                style: const TextStyle(
                  color: Color(0xFF9A8174),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                spec.value,
                style: const TextStyle(
                  color: Color(0xFF1A1C1C),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
