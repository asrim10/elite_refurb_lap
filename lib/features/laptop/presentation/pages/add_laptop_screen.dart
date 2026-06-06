import 'dart:io';

import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/presentation/view_model/laptop_viewmodel.dart';
import 'package:EliteReurbLap/features/laptop/presentation/state/laptop_state.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/add_laptop_section_label.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/add_laptop_text_field.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/condition_chip.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/image_picker_area.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/location_picker_map.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/price_field.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/step_progress_bar.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/storage_type_chip.dart';
import 'package:baato_maps/baato_maps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddLaptopScreen extends ConsumerStatefulWidget {
  const AddLaptopScreen({super.key});

  @override
  ConsumerState<AddLaptopScreen> createState() => _AddLaptopScreenState();
}

class _AddLaptopScreenState extends ConsumerState<AddLaptopScreen> {
  final _pageController = PageController();
  final _imagePicker = ImagePicker();

  // Controllers
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _processorController = TextEditingController();
  final _ramController = TextEditingController();
  final _storageController = TextEditingController();
  final _displaySizeController = TextEditingController();
  final _displayResolutionController = TextEditingController();
  final _gpuController = TextEditingController();
  final _operatingSystemController = TextEditingController();
  final _batteryLifeController = TextEditingController();
  final _weightController = TextEditingController();
  final _yearController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _addressController = TextEditingController();
  final _tagsController = TextEditingController();

  // State
  String _condition = 'excellent';
  String _storageType = 'SSD';
  final List<File> _selectedImages = [];
  BaatoCoordinate? _selectedLocation;
  bool _isSubmitting = false;
  int _currentStep = 0;

  static const _totalSteps = 5;

  static const _steps = [
    StepInfo(step: 0, label: 'Photos', icon: Icons.photo_library_outlined),
    StepInfo(step: 1, label: 'Details', icon: Icons.edit_outlined),
    StepInfo(step: 2, label: 'Pricing', icon: Icons.attach_money_outlined),
    StepInfo(step: 3, label: 'Specs', icon: Icons.memory_outlined),
    StepInfo(step: 4, label: 'Finalize', icon: Icons.check_circle_outline),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _brandController.dispose();
    _modelNameController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _descriptionController.dispose();
    _processorController.dispose();
    _ramController.dispose();
    _storageController.dispose();
    _displaySizeController.dispose();
    _displayResolutionController.dispose();
    _gpuController.dispose();
    _operatingSystemController.dispose();
    _batteryLifeController.dispose();
    _weightController.dispose();
    _yearController.dispose();
    _warrantyController.dispose();
    _addressController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  // --- Image Picker ---

  Future<void> _pickImage() async {
    await _showImageSourceModal();
  }

  Future<void> _showImageSourceModal() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF9F9F9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFCDC4CA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1C1C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a source to add photos',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickFromCamera();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickFromGallery();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF8A3030),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCDC4CA)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: const Color(0xFF4B454A)),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B454A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showSnackBar('Camera permission is required to take photos');
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _selectedImages.add(File(image.path)));
    }
  }

  Future<void> _pickFromGallery() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        _showSnackBar('Gallery permission is required to select photos');
        return;
      }
    }

    final images = await _imagePicker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // --- Step Navigation ---

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        // Photos are optional — allow proceeding without photos
        return true;
      case 1: // Details
        final title = _titleController.text.trim();
        final brand = _brandController.text.trim();
        final model = _modelNameController.text.trim();
        if (title.length < 3) {
          _showSnackBar('Title must be at least 3 characters');
          return false;
        }
        if (brand.isEmpty) {
          _showSnackBar('Brand is required');
          return false;
        }
        if (model.isEmpty) {
          _showSnackBar('Model name is required');
          return false;
        }
        return true;
      case 2: // Pricing
        final priceText = _priceController.text.trim();
        final price = double.tryParse(priceText);
        if (price == null || price <= 0) {
          _showSnackBar('Please enter a valid price');
          return false;
        }
        final desc = _descriptionController.text.trim();
        if (desc.isNotEmpty && desc.length < 10) {
          _showSnackBar('Description must be at least 10 characters');
          return false;
        }
        return true;
      case 3: // Specs
        final processor = _processorController.text.trim();
        final ramText = _ramController.text.trim();
        final storageText = _storageController.text.trim();
        final displayText = _displaySizeController.text.trim();
        if (processor.isEmpty) {
          _showSnackBar('Processor is required');
          return false;
        }
        if (int.tryParse(ramText) == null || int.parse(ramText) <= 0) {
          _showSnackBar('Please enter a valid RAM size');
          return false;
        }
        if (int.tryParse(storageText) == null || int.parse(storageText) <= 0) {
          _showSnackBar('Please enter a valid storage size');
          return false;
        }
        if (double.tryParse(displayText) == null ||
            double.parse(displayText) <= 0) {
          _showSnackBar('Please enter a valid display size');
          return false;
        }
        final yearText = _yearController.text.trim();
        if (yearText.isNotEmpty) {
          final year = int.tryParse(yearText);
          final currentYear = DateTime.now().year;
          if (year == null || year < 2000 || year > currentYear) {
            _showSnackBar('Year must be between 2000 and $currentYear');
            return false;
          }
        }
        return true;
      case 4: // Finalize — no validation needed
        return true;
      default:
        return true;
    }
  }

  void _goToStep(int step) {
    if (step < 0 || step >= _totalSteps) return;
    final goingForward = step > _currentStep;
    if (goingForward && !_validateStep(_currentStep)) return;

    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
  }

  void _nextStep() => _goToStep(_currentStep + 1);
  void _previousStep() => _goToStep(_currentStep - 1);

  // --- Form Submission ---

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    final price = double.tryParse(_priceController.text) ?? 0;
    final ram = int.tryParse(_ramController.text) ?? 0;
    final storage = int.tryParse(_storageController.text) ?? 0;
    final displaySize = double.tryParse(_displaySizeController.text) ?? 0;

    final userId =
        ref.read(userSessionServiceProvider).getCurrentUserId() ?? '';
    if (userId.isEmpty) {
      _showSnackBar('User session not found. Please login again.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewmodel = ref.read(laptopViewModelProvider.notifier);

      // Upload images
      final imageUrls = <String>[];
      for (final image in _selectedImages) {
        final multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
        final url = await viewmodel.uploadImage(multipartFile);
        if (url != null) imageUrls.add(url);
      }

      // Build location
      LaptopLocationEntity? location;
      if (_selectedLocation != null) {
        location = LaptopLocationEntity(
          lat: _selectedLocation!.latitude,
          lng: _selectedLocation!.longitude,
          address: _addressController.text.trim(),
        );
      }

      // Parse tags
      final tags = _tagsController.text.trim().isNotEmpty
          ? _tagsController.text
              .trim()
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList()
          : <String>[];

      // Create listing
      await viewmodel.createLaptop(
        title: _titleController.text.trim(),
        brand: _brandController.text.trim(),
        modelName: _modelNameController.text.trim(),
        price: price,
        originalPrice: _originalPriceController.text.isNotEmpty
            ? double.tryParse(_originalPriceController.text)
            : null,
        condition: _condition,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        images: imageUrls,
        processor: _processorController.text.trim(),
        ram: ram,
        storage: storage,
        storageType: _storageType,
        displaySize: displaySize,
        displayResolution:
            _displayResolutionController.text.trim().isNotEmpty
                ? _displayResolutionController.text.trim()
                : null,
        gpu: _gpuController.text.trim().isNotEmpty
            ? _gpuController.text.trim()
            : null,
        operatingSystem: _operatingSystemController.text.trim().isNotEmpty
            ? _operatingSystemController.text.trim()
            : null,
        batteryLife: _batteryLifeController.text.isNotEmpty
            ? double.tryParse(_batteryLifeController.text)
            : null,
        weight: _weightController.text.isNotEmpty
            ? double.tryParse(_weightController.text)
            : null,
        sellerId: userId,
        yearOfManufacture: _yearController.text.isNotEmpty
            ? int.tryParse(_yearController.text)
            : null,
        warrantyMonths: _warrantyController.text.isNotEmpty
            ? int.tryParse(_warrantyController.text) ?? 0
            : null,
        location: location,
        tags: tags,
      );
    } catch (e) {
      _showSnackBar('Error: $e');
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8A3030),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- Build Steps ---

  Widget _buildStepPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AddLaptopSectionLabel(label: 'PRODUCT IMAGES'),
        const SizedBox(height: 4),
        const Text(
          'Add up to clear photos of your laptop',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        ImagePickerArea(
          selectedImages: _selectedImages,
          onPickImage: _pickImage,
          onRemoveImage: _removeImage,
        ),
      ],
    );
  }

  Widget _buildStepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddLaptopTextField(
          controller: _titleController,
          label: 'Product Title',
          hintText: 'e.g. MacBook Pro 14" M2',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _brandController,
                label: 'Brand',
                hintText: 'e.g. Apple',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _modelNameController,
                label: 'Model Name',
                hintText: 'e.g. MacBook Pro',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const AddLaptopSectionLabel(label: 'CONDITION'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ConditionChip(
              label: 'EXCELLENT',
              value: 'excellent',
              isSelected: _condition == 'excellent',
              onTap: () => setState(() => _condition = 'excellent'),
            ),
            ConditionChip(
              label: 'GOOD',
              value: 'good',
              isSelected: _condition == 'good',
              onTap: () => setState(() => _condition = 'good'),
            ),
            ConditionChip(
              label: 'FAIR',
              value: 'fair',
              isSelected: _condition == 'fair',
              onTap: () => setState(() => _condition = 'fair'),
            ),
            ConditionChip(
              label: 'POOR',
              value: 'poor',
              isSelected: _condition == 'poor',
              onTap: () => setState(() => _condition = 'poor'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AddLaptopSectionLabel(label: 'SELLING PRICE'),
        const SizedBox(height: 6),
        PriceField(
          controller: _priceController,
          label: 'Selling Price',
        ),
        const SizedBox(height: 16),
        const AddLaptopSectionLabel(label: 'ORIGINAL PRICE (optional)'),
        const SizedBox(height: 6),
        PriceField(
          controller: _originalPriceController,
          label: 'Original Price',
        ),
        const SizedBox(height: 16),
        const AddLaptopSectionLabel(label: 'DESCRIPTION (optional)'),
        const SizedBox(height: 6),
        const Text(
          'Describe the condition, any defects, accessories included...',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
        ),
        const SizedBox(height: 8),
        AddLaptopTextField(
          controller: _descriptionController,
          label: 'Description',
          hintText: 'Write a detailed description...',
          expands: true,
        ),
      ],
    );
  }

  Widget _buildStepSpecs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddLaptopTextField(
          controller: _processorController,
          label: 'Processor',
          hintText: 'e.g. Apple M2, i7',
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _ramController,
                label: 'RAM',
                hintText: 'Size in GB',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _storageController,
                label: 'Storage',
                hintText: 'Size in GB',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const AddLaptopSectionLabel(label: 'STORAGE TYPE'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StorageTypeChip(
              label: 'SSD',
              value: 'SSD',
              isSelected: _storageType == 'SSD',
              onTap: () => setState(() => _storageType = 'SSD'),
            ),
            StorageTypeChip(
              label: 'HDD',
              value: 'HDD',
              isSelected: _storageType == 'HDD',
              onTap: () => setState(() => _storageType = 'HDD'),
            ),
            StorageTypeChip(
              label: 'eMMC',
              value: 'eMMC',
              isSelected: _storageType == 'eMMC',
              onTap: () => setState(() => _storageType = 'eMMC'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _displaySizeController,
                label: 'Display Size',
                hintText: 'In inches',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _displayResolutionController,
                label: 'Resolution',
                hintText: 'e.g. 2560x1600',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _gpuController,
                label: 'GPU',
                hintText: 'e.g. M2 Pro (optional)',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _operatingSystemController,
                label: 'Operating System',
                hintText: 'e.g. macOS (optional)',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _batteryLifeController,
                label: 'Battery Life',
                hintText: 'In hours',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _weightController,
                label: 'Weight',
                hintText: 'In kg',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AddLaptopTextField(
                controller: _yearController,
                label: 'Year of Manufacture',
                hintText: 'e.g. 2023',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AddLaptopTextField(
                controller: _warrantyController,
                label: 'Warranty',
                hintText: 'In months',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepFinalize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary preview
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: const Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCDC4CA)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUMMARY',
                style: TextStyle(
                  color: Color(0xFF4B454A),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.88,
                ),
              ),
              const SizedBox(height: 10),
              _buildSummaryRow(
                'Title', _titleController.text.trim()),
              _buildSummaryRow(
                'Brand/Model',
                '${_brandController.text.trim()} ${_modelNameController.text.trim()}'),
              _buildSummaryRow('Condition', _condition.toUpperCase()),
              _buildSummaryRow(
                'Price',
                'Rs ${_priceController.text.trim()}'),
              _buildSummaryRow(
                'Photos', '${_selectedImages.length} selected'),
              _buildSummaryRow(
                'Processor', _processorController.text.trim()),
              _buildSummaryRow(
                'RAM/Storage',
                '${_ramController.text.trim()}GB / ${_storageController.text.trim()}GB $_storageType'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Location
        const AddLaptopSectionLabel(label: 'LOCATION'),
        const SizedBox(height: 6),
        LocationPickerMap(
          autoDetect: true,
          selectedLocation: _selectedLocation,
          onTap: (point) {
            setState(() => _selectedLocation = point);
          },
          onUseCurrentLocation: () {
            setState(() {
              _selectedLocation = BaatoCoordinate(
                latitude: 27.7172,
                longitude: 85.3240,
              );
            });
          },
          addressController: _addressController,
        ),

        const SizedBox(height: 16),

        // Tags
        const AddLaptopSectionLabel(label: 'TAGS (comma-separated)'),
        const SizedBox(height: 6),
        AddLaptopTextField(
          controller: _tagsController,
          label: 'Tags',
          hintText: 'e.g. laptop, gaming, ultrabook',
        ),


      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Main Build ---

  @override
  Widget build(BuildContext context) {
    ref.listen<LaptopState>(laptopViewModelProvider, (prev, state) {
      if (state.status == LaptopStatus.created && mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing posted successfully!'),
            backgroundColor: Color(0xFF2D6A3F),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      } else if (state.status == LaptopStatus.error &&
          mounted &&
          _isSubmitting) {
        setState(() => _isSubmitting = false);
        _showSnackBar(state.errorMessage ?? 'Failed to post listing');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: const ShapeDecoration(
                color: Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Post Listings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            // Step Progress Bar
            StepProgressBar(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              steps: _steps,
            ),

            // Page View for Steps
            Expanded(
              child: Form(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() => _currentStep = page);
                  },
                  children: [
                    // Step 0: Photos
                    _buildPage('Add Photos', [
                      _buildStepPhotos(),
                    ]),
                    // Step 1: Details
                    _buildPage('Basic Details', [
                      _buildStepDetails(),
                    ]),
                    // Step 2: Pricing
                    _buildPage('Pricing & Description', [
                      _buildStepPricing(),
                    ]),
                    // Step 3: Specs
                    _buildPage('Technical Specifications', [
                      _buildStepSpecs(),
                    ]),
                    // Step 4: Finalize
                    _buildPage('Review & Post', [
                      _buildStepFinalize(),
                    ]),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1A1C1C),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE5E0DB), height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final isLastStep = _currentStep == _totalSteps - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1, color: Color(0xFFE5E0DB)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Back button
            if (_currentStep > 0)
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCDC4CA)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF4B454A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Spacer(),

            if (_currentStep > 0) const SizedBox(width: 12),

            // Next or Submit button
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: isLastStep
                      ? (_isSubmitting ? null : _submitForm)
                      : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    elevation: 0,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isLastStep && _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            isLastStep ? 'POST LISTING' : 'Next',
                            key: ValueKey(isLastStep),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
