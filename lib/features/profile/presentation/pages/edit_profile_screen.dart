import 'dart:io';

import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/bottom_save_bar.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/edit_profile_app_bar.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/edit_profile_phone_field.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/edit_profile_text_field.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/image_source_modal.dart';
import 'package:EliteReurbLap/features/profile/presentation/widgets/profile_photo_section.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  File? _pickedImage;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  bool _isRemovingPhoto = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authViewModelProvider).authEntity;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;
    final initials = _getInitials(user?.fullName ?? 'U');

    ref.listen(authViewModelProvider, (prev, next) {
      if (prev?.status == AuthStatus.profileUpdating &&
          next.status == AuthStatus.profileUpdated &&
          !_isUploadingPhoto &&
          !_isRemovingPhoto) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (next.status == AuthStatus.error &&
          next.errorMessage != null &&
          prev?.status == AuthStatus.profileUpdating) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 72,
              left: 20,
              right: 20,
              bottom: 140,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo Section
                  ProfilePhotoSection(
                    initials: initials,
                    user: user,
                    pickedImage: _pickedImage,
                    isUploadingPhoto: _isUploadingPhoto,
                    isRemovingPhoto: _isRemovingPhoto,
                    onChangePhoto: _onChangePhoto,
                    onRemovePhoto: _onRemovePhoto,
                  ),
                  const SizedBox(height: 24),

                  // Form Fields
                  _buildFormFields(),
                ],
              ),
            ),
          ),

          // Bottom Save Button
          BottomSaveBar(
            isSaving: _isSaving,
            onSave: _onSaveChanges,
          ),

          // Top App Bar
          EditProfileAppBar(
            onBack: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      spacing: 16,
      children: [
        // Full Name
        EditProfileTextField(
          label: 'Full Name',
          controller: _fullNameController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),

        // Email Address
        EditProfileTextField(
          label: 'Email Address',
          controller: _emailController,
          enabled: false,
        ),

        // Phone Number
        EditProfilePhoneField(
          controller: _phoneController,
        ),
      ],
    );
  }

  void _onChangePhoto() {
    ImageSourceModal.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
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
      await _processPickedImage(File(image.path));
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

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      await _processPickedImage(File(image.path));
    }
  }

  Future<void> _processPickedImage(File image) async {
    // Show local preview immediately
    setState(() {
      _pickedImage = image;
      _isUploadingPhoto = true;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final multipartFile = await MultipartFile.fromFile(
        image.path,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final formData = FormData.fromMap({'image': multipartFile});

      final response = await apiClient.uploadFile(
        '${ApiEndpoints.laptops}/upload',
        formData: formData,
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final imageUrl = data['url'] as String;

      // Update profile with the new image URL
      await ref
          .read(authViewModelProvider.notifier)
          .updateProfile(imageUrl: imageUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile photo updated'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      // Revert local preview on failure
      setState(() => _pickedImage = null);
      if (mounted) {
        _showSnackBar('Failed to upload photo: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  Future<void> _onRemovePhoto() async {
    if (_pickedImage == null && ref.read(authViewModelProvider).authEntity?.imageUrl == null) return;

    setState(() {
      _pickedImage = null;
      _isRemovingPhoto = true;
    });

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .updateProfile(imageUrl: '');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile photo removed'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to remove photo: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isRemovingPhoto = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await ref
        .read(authViewModelProvider.notifier)
        .updateProfile(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0].toUpperCase();
    }
    return 'U';
  }
}
