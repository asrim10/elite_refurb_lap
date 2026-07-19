import 'package:EliteReurbLap/features/search/domain/search_filter.dart';
import 'package:flutter/material.dart';

class SearchFilterSheet extends StatefulWidget {
  final SearchFilter currentFilter;

  const SearchFilterSheet({super.key, required this.currentFilter});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late String? _selectedLaptopType;
  late String? _selectedProcessor;
  late String? _selectedRam;
  late String? _selectedStorage;
  late RangeValues _priceRange;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _selectedLaptopType = widget.currentFilter.laptopType;
    _selectedProcessor = widget.currentFilter.processor;
    _selectedRam = widget.currentFilter.ram;
    _selectedStorage = widget.currentFilter.storage;
    _priceRange = RangeValues(
      widget.currentFilter.minPrice,
      widget.currentFilter.maxPrice,
    );
    _minPriceController = TextEditingController(
      text: widget.currentFilter.minPrice.toStringAsFixed(0),
    );
    _maxPriceController = TextEditingController(
      text: widget.currentFilter.maxPrice.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onApply() {
    final filter = SearchFilter(
      laptopType: _selectedLaptopType,
      processor: _selectedProcessor,
      ram: _selectedRam,
      storage: _selectedStorage,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
    );
    Navigator.of(context).pop(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle + Close button
          _buildHandleAndClose(),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('LAPTOP TYPE'),
                  const SizedBox(height: 16),
                  _buildLaptopTypeChips(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('TECHNICAL SPECIFICATIONS'),
                  const SizedBox(height: 16),
                  _buildSpecSection(
                    label: 'Processor',
                    options: SearchFilter.processors,
                    selected: _selectedProcessor,
                    onSelected: (v) => setState(() => _selectedProcessor = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSpecSection(
                    label: 'RAM',
                    options: SearchFilter.ramOptions,
                    selected: _selectedRam,
                    onSelected: (v) => setState(() => _selectedRam = v),
                  ),
                  const SizedBox(height: 16),
                  _buildSpecSection(
                    label: 'Storage',
                    options: SearchFilter.storageOptions,
                    selected: _selectedStorage,
                    onSelected: (v) => setState(() => _selectedStorage = v),
                  ),
                  const SizedBox(height: 24),
                  _buildPriceRangeSection(),
                ],
              ),
            ),
          ),
          // Bottom actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _selectedLaptopType = null;
      _selectedProcessor = null;
      _selectedRam = null;
      _selectedStorage = null;
      _priceRange = RangeValues(
        SearchFilter.defaultMinPrice,
        SearchFilter.defaultMaxPrice,
      );
      _minPriceController.text =
          SearchFilter.defaultMinPrice.toStringAsFixed(0);
      _maxPriceController.text =
          SearchFilter.defaultMaxPrice.toStringAsFixed(0);
    });
  }

  Widget _buildHandleAndClose() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 24),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: ShapeDecoration(
                color: const Color(0xFFE2E2E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Close + Clear All row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clear All button
              GestureDetector(
                onTap: _clearAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F0EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        size: 14,
                        color: Color(0xFF6B5A50),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Clear All',
                        style: TextStyle(
                          color: Color(0xFF6B5A50),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Close button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(Icons.close, size: 24, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF766054),
        fontSize: 11,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: 1.10,
      ),
    );
  }

  Widget _buildLaptopTypeChips() {
    return Column(
      children: SearchFilter.laptopTypes.map((type) {
        final isSelected = _selectedLaptopType == type;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedLaptopType = isSelected ? null : type;
            }),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: ShapeDecoration(
                color: isSelected ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: isSelected ? 2 : 1,
                    color: isSelected ? Colors.black : const Color(0xFFCDC4CA),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1A1C1C),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecSection({
    required String label,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1A1C1C),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.38,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isActive = selected == option;
            return GestureDetector(
              onTap: () => onSelected(isActive ? null : option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: ShapeDecoration(
                  color: isActive ? const Color(0xFF705A4E) : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: isActive ? 2 : 1,
                      color: isActive
                          ? const Color(0xFF705A4E)
                          : const Color(0xFFCDC4CA),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    height: 1.38,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('PRICE RANGE'),
            Text(
              'Rs. ${_priceRange.start.toStringAsFixed(0)} - Rs. ${_priceRange.end.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Range slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.black,
            inactiveTrackColor: const Color(0xFFE2E2E2),
            overlayColor: Colors.black.withValues(alpha: 0.12),
            thumbColor: Colors.black,
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: SearchFilter.minPriceLimit,
            max: SearchFilter.maxPriceLimit,
            divisions: 40,
            labels: RangeLabels(
              'Rs. ${_priceRange.start.toStringAsFixed(0)}',
              'Rs. ${_priceRange.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
                _minPriceController.text = values.start.toStringAsFixed(0);
                _maxPriceController.text = values.end.toStringAsFixed(0);
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        // Min/Max input fields
        Row(
          children: [
            Expanded(
              child: _buildPriceInput(
                label: 'MIN',
                controller: _minPriceController,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() {
                      _priceRange = RangeValues(
                        parsed.clamp(
                          SearchFilter.minPriceLimit,
                          _priceRange.end,
                        ),
                        _priceRange.end,
                      );
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPriceInput(
                label: 'MAX',
                controller: _maxPriceController,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    setState(() {
                      _priceRange = RangeValues(
                        _priceRange.start,
                        parsed.clamp(
                          _priceRange.start,
                          SearchFilter.maxPriceLimit,
                        ),
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceInput({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF766054),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.38,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              prefixText: 'Rs. ',
              prefixStyle: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x19CDC4CA)),
        ),
      ),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 52,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Apply Filters button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _onApply,
              child: Container(
                height: 52,
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Apply Filters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
