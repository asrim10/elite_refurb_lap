import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/rating/presentation/widgets/star_rating_input.dart';

/// Shows a modal bottom sheet for rating a seller.
///
/// Returns `true` if the rating was submitted successfully, `null` if dismissed.
Future<bool?> showSellerRatingSheet(
  BuildContext context, {
  required String sellerId,
  required String sellerName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SellerRatingSheet(
      sellerId: sellerId,
      sellerName: sellerName,
    ),
  );
}

class _SellerRatingSheet extends ConsumerStatefulWidget {
  final String sellerId;
  final String sellerName;

  const _SellerRatingSheet({
    required this.sellerId,
    required this.sellerName,
  });

  @override
  ConsumerState<_SellerRatingSheet> createState() =>
      _SellerRatingSheetState();
}

class _SellerRatingSheetState extends ConsumerState<_SellerRatingSheet> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        ApiEndpoints.ratings,
        data: {
          'ratedSellerId': widget.sellerId,
          'rating': _rating,
          if (_reviewController.text.trim().isNotEmpty)
            'review': _reviewController.text.trim(),
        },
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 24 + bottomInset,
        ),
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
            // Title
            const Text(
              'Rate Seller',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'How was your experience with\n${widget.sellerName}?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF7C757A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
            const SizedBox(height: 24),
            // Star rating
            StarRatingInput(
              rating: _rating,
              onRatingChanged: (value) => setState(() => _rating = value),
              starSize: 40,
            ),
            const SizedBox(height: 8),
            Text(
              _rating > 0 ? _ratingLabel(_rating) : 'Tap a star to rate',
              style: TextStyle(
                color: _rating > 0
                    ? const Color(0xFF705A4E)
                    : const Color(0xFFCDC4CA),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Review text field
            TextField(
              controller: _reviewController,
              maxLines: 3,
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write a review (optional)',
                hintStyle: const TextStyle(
                  color: Color(0xFFCDC4CA),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0x4CCDC4CA),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0x4CCDC4CA),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF705A4E),
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _rating > 0 && !_isSubmitting ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0xFFCDC4CA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SUBMIT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.88,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            // Skip / Cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF7C757A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
