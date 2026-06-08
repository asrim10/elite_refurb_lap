import 'dart:io';

import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter/material.dart';

class ProfilePhotoSection extends StatelessWidget {
  final String initials;
  final AuthEntity? user;
  final File? pickedImage;
  final bool isUploadingPhoto;
  final bool isRemovingPhoto;
  final VoidCallback onChangePhoto;
  final VoidCallback onRemovePhoto;

  const ProfilePhotoSection({
    super.key,
    required this.initials,
    required this.user,
    required this.pickedImage,
    required this.isUploadingPhoto,
    required this.isRemovingPhoto,
    required this.onChangePhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedImage != null || user?.imageUrl != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                padding: const EdgeInsets.all(4),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0xFFCDC4CA),
                    ),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    image: pickedImage != null
                        ? DecorationImage(
                            image: FileImage(pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : user?.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  ApiEndpoints.getImageUrl(user!.imageUrl!),
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                    color: pickedImage == null && user?.imageUrl == null
                        ? AppColors.accent
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                  child: pickedImage == null && user?.imageUrl == null
                      ? Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : isUploadingPhoto
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : null,
                ),
              ),
              // Camera edit button
              Positioned(
                right: 4,
                bottom: 4,
                child: GestureDetector(
                  onTap:
                      (isUploadingPhoto || isRemovingPhoto) ? null : onChangePhoto,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFFF9F9F9),
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap:
                (isUploadingPhoto || isRemovingPhoto) ? null : onChangePhoto,
            child: Text(
              isUploadingPhoto
                  ? 'UPLOADING...'
                  : isRemovingPhoto
                      ? 'REMOVING...'
                      : 'CHANGE PHOTO',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF705A4E),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.10,
              ),
            ),
          ),
          // Remove Photo option (only when a photo is set)
          if (hasImage)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GestureDetector(
                onTap: (isUploadingPhoto || isRemovingPhoto)
                    ? null
                    : onRemovePhoto,
                child: Text(
                  isRemovingPhoto ? 'REMOVING...' : 'REMOVE PHOTO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isRemovingPhoto
                        ? const Color(0xFFBA1A1A).withValues(alpha: 0.5)
                        : const Color(0xFFBA1A1A),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
