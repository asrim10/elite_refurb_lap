import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerArea extends StatelessWidget {
  final List<File> selectedImages;
  final VoidCallback onPickImage;
  final ValueChanged<int> onRemoveImage;

  const ImagePickerArea({
    super.key,
    required this.selectedImages,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedImages.isNotEmpty) {
      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: selectedImages.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index < selectedImages.length) {
              return _buildImageThumbnail(index);
            }
            return _buildAddButton();
          },
        ),
      );
    }
    return _buildUploadArea();
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: ShapeDecoration(
          color: const Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFCDC4CA)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: const Color(0xFF4B454A).withValues(alpha: 0.6),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add Photo',
              style: TextStyle(
                color: Color(0xFF4B454A),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: ShapeDecoration(
          color: const Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFCDC4CA)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 32,
          color: const Color(0xFF4B454A).withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index) {
    final file = selectedImages[index];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveImage(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const ShapeDecoration(
                color: Color(0xCC000000),
                shape: CircleBorder(),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
