import 'dart:io';

import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/add_laptop_section_label.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/add_laptop_text_field.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/condition_chip.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/image_picker_area.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/location_picker_map.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/price_field.dart';
import 'package:EliteReurbLap/features/laptop/presentation/widgets/storage_type_chip.dart';
import 'package:baato_maps/baato_maps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddLaptopScreen extends ConsumerStatefulWidget {
  const AddLaptopScreen({super.key});

  @override
  ConsumerState<AddLaptopScreen> createState() => _AddLaptopScreenState();
}

class _AddLaptopScreenState extends ConsumerState<AddLaptopScreen> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  void dispose() {
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

  // Image Picker
  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _selectedImages.add(File(image.path)));
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // Form Submission
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text) ?? 0;
    final ram = int.tryParse(_ramController.text) ?? 0;
    final storage = int.tryParse(_storageController.text) ?? 0;
    final displaySize = double.tryParse(_displaySizeController.text) ?? 0;

    if (price <= 0) {
      _showSnackBar('Please enter a valid price');
      return;
    }
    if (ram <= 0) {
      _showSnackBar('Please enter RAM size');
      return;
    }
    if (storage <= 0) {
      _showSnackBar('Please enter storage size');
      return;
    }
    if (displaySize <= 0) {
      _showSnackBar('Please enter display size');
      return;
    }

    final userId =
        ref.read(userSessionServiceProvider).getCurrentUserId() ?? '';
    if (userId.isEmpty) {
      _showSnackBar('User session not found. Please login again.');
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = {
      'title': _titleController.text.trim(),
      'brand': _brandController.text.trim(),
      'modelName': _modelNameController.text.trim(),
      'price': price,
      'originalPrice': _originalPriceController.text.isNotEmpty
          ? double.tryParse(_originalPriceController.text)
          : null,
      'condition': _condition,
      'status': 'available',
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      'images': <String>[], // uploaded separately via multipart
      'processor': _processorController.text.trim(),
      'ram': ram,
      'storage': storage,
      'storageType': _storageType,
      'displaySize': displaySize,
      'displayResolution': _displayResolutionController.text.trim().isNotEmpty
          ? _displayResolutionController.text.trim()
          : null,
      'gpu': _gpuController.text.trim().isNotEmpty
          ? _gpuController.text.trim()
          : null,
      'operatingSystem': _operatingSystemController.text.trim().isNotEmpty
          ? _operatingSystemController.text.trim()
          : null,
      'batteryLife': _batteryLifeController.text.isNotEmpty
          ? double.tryParse(_batteryLifeController.text)
          : null,
      'weight': _weightController.text.isNotEmpty
          ? double.tryParse(_weightController.text)
          : null,
      'sellerId': userId,
      'yearOfManufacture': _yearController.text.isNotEmpty
          ? int.tryParse(_yearController.text)
          : null,
      'warrantyMonths': _warrantyController.text.isNotEmpty
          ? int.tryParse(_warrantyController.text) ?? 0
          : 0,
      'location': _selectedLocation != null
          ? {
              'lat': _selectedLocation!.latitude,
              'lng': _selectedLocation!.longitude,
              'address': _addressController.text.trim(),
            }
          : null,
      'tags': _tagsController.text.trim().isNotEmpty
          ? _tagsController.text
                .trim()
                .split(',')
                .map((t) => t.trim())
                .where((t) => t.isNotEmpty)
                .toList()
          : <String>[],
    };

    try {
      final apiClient = ref.read(apiClientProvider);
      // Upload images first
      final imageUrls = <String>[];
      for (final image in _selectedImages) {
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        });
        final uploadRes = await apiClient.uploadFile(
          '/laptops/upload',
          formData: formData,
        );
        if (uploadRes.statusCode == 200 || uploadRes.statusCode == 201) {
          final url = uploadRes.data['url'] as String?;
          if (url != null) imageUrls.add(url);
        }
      }
      payload['images'] = imageUrls;

      // Create laptop
      final res = await apiClient.post('/laptops', data: payload);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Listing posted successfully!'),
              backgroundColor: Color(0xFF2D6A3F),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        _showSnackBar('Failed to post listing. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
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

  @override
  Widget build(BuildContext context) {
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

            // Scrollable Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    // PRODUCT IMAGES
                    const AddLaptopSectionLabel(label: 'PRODUCT IMAGES'),
                    const SizedBox(height: 8),
                    ImagePickerArea(
                      selectedImages: _selectedImages,
                      onPickImage: _pickImage,
                      onRemoveImage: _removeImage,
                    ),

                    const SizedBox(height: 24),

                    // PRODUCT TITLE
                    const AddLaptopSectionLabel(label: 'PRODUCT TITLE'),
                    const SizedBox(height: 6),
                    AddLaptopTextField(
                      controller: _titleController,
                      hintText: 'e.g. MacBook Pro 14" M2',
                      validator: (v) => (v == null || v.trim().length < 3)
                          ? 'Title must be at least 3 characters'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // BRAND & MODEL
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AddLaptopSectionLabel(label: 'BRAND'),
                              const SizedBox(height: 6),
                              AddLaptopTextField(
                                controller: _brandController,
                                hintText: 'e.g. Apple',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AddLaptopSectionLabel(label: 'MODEL NAME'),
                              const SizedBox(height: 6),
                              AddLaptopTextField(
                                controller: _modelNameController,
                                hintText: 'e.g. MacBook Pro',
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // PRICE
                    const AddLaptopSectionLabel(label: 'PRICE'),
                    const SizedBox(height: 6),
                    PriceField(
                      controller: _priceController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Required';
                        }
                        final val = double.tryParse(v);
                        if (val == null || val <= 0) {
                          return 'Enter a valid price';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ORIGINAL PRICE (optional)
                    const AddLaptopSectionLabel(
                      label: 'ORIGINAL PRICE (optional)',
                    ),
                    const SizedBox(height: 6),
                    PriceField(controller: _originalPriceController),

                    const SizedBox(height: 16),

                    // CONDITION
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

                    const SizedBox(height: 16),

                    // DESCRIPTION
                    const AddLaptopSectionLabel(
                      label: 'DESCRIPTION (optional)',
                    ),
                    const SizedBox(height: 6),
                    AddLaptopTextField(
                      controller: _descriptionController,
                      hintText:
                          'Describe the condition, any defects, accessories included...',
                      expands: true,
                      validator: (v) {
                        if (v != null &&
                            v.trim().isNotEmpty &&
                            v.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // TECHNICAL SPECIFICATIONS
                    const AddLaptopSectionLabel(
                      label: 'TECHNICAL SPECIFICATIONS',
                    ),
                    const SizedBox(height: 8),
                    AddLaptopTextField(
                      controller: _processorController,
                      hintText: 'e.g. Apple M2, Intel Core i7-13700H',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Processor is required'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _ramController,
                            hintText: 'RAM (GB)',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              final val = int.tryParse(v);
                              if (val == null || val <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _storageController,
                            hintText: 'Storage (GB)',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              final val = int.tryParse(v);
                              if (val == null || val <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // STORAGE TYPE
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

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _displaySizeController,
                            hintText: 'Screen (inches)',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Required';
                              }
                              final val = double.tryParse(v);
                              if (val == null || val <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _displayResolutionController,
                            hintText: 'Resolution',
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
                            hintText: 'GPU (optional)',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _operatingSystemController,
                            hintText: 'OS (optional)',
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
                            hintText: 'Battery (hrs)',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _weightController,
                            hintText: 'Weight (kg)',
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
                            hintText: 'Year (e.g. 2023)',
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v != null && v.trim().isNotEmpty) {
                                final year = int.tryParse(v);
                                final currentYear = DateTime.now().year;
                                if (year == null ||
                                    year < 2000 ||
                                    year > currentYear) {
                                  return 'Year must be between 2000 and $currentYear';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AddLaptopTextField(
                            controller: _warrantyController,
                            hintText: 'Warranty (months)',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // LOCATION (Baato Maps)
                    const AddLaptopSectionLabel(label: 'LOCATION'),
                    const SizedBox(height: 6),
                    LocationPickerMap(
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

                    // TAGS
                    const AddLaptopSectionLabel(
                      label: 'TAGS (comma-separated)',
                    ),
                    const SizedBox(height: 6),
                    AddLaptopTextField(
                      controller: _tagsController,
                      hintText: 'e.g. laptop, gaming, ultrabook',
                    ),

                    const SizedBox(height: 32),

                    // SUBMIT BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: Colors.black.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _isSubmitting
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
                              : const Text(
                                  'POST LISTING',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.40,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
