import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

class LaptopSpecsTable extends StatelessWidget {
  final LaptopEntity laptop;

  const LaptopSpecsTable({super.key, required this.laptop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
            ),
          ),
          child: Column(
            children: [
              _specRow(label: 'RAM', value: '${laptop.ram} GB'),
              _divider(),
              _specRow(label: 'Storage', value: '${laptop.storage} GB ${laptop.storageType}'),
              _divider(),
              _specRow(
                label: 'Battery',
                value: laptop.batteryLife != null
                    ? '${laptop.batteryLife!.toStringAsFixed(0)}% health'
                    : 'N/A',
              ),
              _divider(),
              _specRow(
                label: 'Condition',
                value: laptop.condition[0].toUpperCase() + laptop.condition.substring(1),
              ),
              _divider(),
              _specRow(
                label: 'Year',
                value: laptop.yearOfManufacture?.toString() ?? 'N/A',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _specRow({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B454A),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: const Color(0xFFCDC4CA),
    );
  }
}
