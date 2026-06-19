import 'package:flutter/material.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';

class LaptopImageGallery extends StatefulWidget {
  final List<String> images;

  const LaptopImageGallery({super.key, required this.images});

  @override
  State<LaptopImageGallery> createState() => _LaptopImageGalleryState();
}

class _LaptopImageGalleryState extends State<LaptopImageGallery> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        color: const Color(0xFFE8E0D8),
        child: const Center(
          child: Icon(Icons.laptop_mac, size: 48, color: Color(0xFF9A8174)),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image PageView
        SizedBox(
          width: double.infinity,
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                color: const Color(0xFFE8E0D8),
                child: Image.network(
                  ApiEndpoints.getImageUrl(images[index]),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFC4B0A4),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.laptop_mac,
                        size: 48,
                        color: Color(0xFF9A8174),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dynamic dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: List.generate(
            images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _currentIndex == index ? 24 : 6,
              height: 6,
              decoration: ShapeDecoration(
                color: _currentIndex == index
                    ? Colors.black
                    : const Color(0xFF7C757A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
