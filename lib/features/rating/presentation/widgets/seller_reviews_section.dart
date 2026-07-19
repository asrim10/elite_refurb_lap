import 'package:flutter/material.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';

enum ReviewSortOption {
  newest,
  oldest,
  highestRating,
  lowestRating,
}

class SellerReviewsSection extends StatefulWidget {
  final List<RatingEntity> ratings;
  final bool isLoading;

  const SellerReviewsSection({
    super.key,
    required this.ratings,
    this.isLoading = false,
  });

  @override
  State<SellerReviewsSection> createState() => _SellerReviewsSectionState();
}

class _SellerReviewsSectionState extends State<SellerReviewsSection> {
  ReviewSortOption _sortOption = ReviewSortOption.newest;

  List<RatingEntity> get _sortedRatings {
    final sorted = List<RatingEntity>.from(widget.ratings);
    switch (_sortOption) {
      case ReviewSortOption.newest:
        sorted.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(2000);
          final bDate = b.createdAt ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });
        break;
      case ReviewSortOption.oldest:
        sorted.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(2000);
          final bDate = b.createdAt ?? DateTime(2000);
          return aDate.compareTo(bDate);
        });
        break;
      case ReviewSortOption.highestRating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ReviewSortOption.lowestRating:
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF705A4E),
            strokeWidth: 2,
          ),
        ),
      );
    }

    final sorted = _sortedRatings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${widget.ratings.length})',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Sort chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ReviewSortOption.values.map((option) {
              final isSelected = option == _sortOption;
              final label = switch (option) {
                ReviewSortOption.newest => 'Newest',
                ReviewSortOption.oldest => 'Oldest',
                ReviewSortOption.highestRating => 'Highest Rated',
                ReviewSortOption.lowestRating => 'Lowest Rated',
              };
              return Padding(
                padding: EdgeInsets.only(
                  right: option == ReviewSortOption.values.last ? 0 : 8,
                ),
                child: GestureDetector(
                  onTap: () => setState(() => _sortOption = option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: ShapeDecoration(
                      color: isSelected
                          ? const Color(0xFF705A4E)
                          : const Color(0xFFF3F3F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4B454A),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (sorted.isEmpty)
          _buildEmptyState()
        else
          ...sorted.map((rating) => Padding(
                padding: EdgeInsets.only(
                  bottom: rating == sorted.last ? 0 : 12,
                ),
                child: _ReviewCard(rating: rating),
              )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 40,
            color: Color(0xFFCDC4CA),
          ),
          SizedBox(height: 12),
          Text(
            'No reviews yet',
            style: TextStyle(
              color: Color(0xFF9A8174),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Be the first to leave a review!',
            style: TextStyle(
              color: Color(0xFFCDC4CA),
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final RatingEntity rating;

  const _ReviewCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    final userName = rating.ratedByUserFullName ?? 'Anonymous';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final hasImage = rating.ratedByUserImageUrl != null &&
        rating.ratedByUserImageUrl!.isNotEmpty;
    final formattedDate = rating.createdAt != null
        ? _formatDate(rating.createdAt!)
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x4CCDC4CA)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            children: [
              // Avatar
              ClipOval(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: hasImage ? null : const Color(0xFF705A4E),
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(
                              ApiEndpoints.getImageUrl(
                                  rating.ratedByUserImageUrl!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasImage
                      ? null
                      : Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.36,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Color(0xFF9A8174),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
              // Star rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating.rating ? Icons.star : Icons.star_border,
                    size: 14,
                    color: i < rating.rating
                        ? const Color(0xFF705A4E)
                        : const Color(0xFFCDC4CA),
                  );
                }),
              ),
            ],
          ),
          // Review text
          if (rating.review != null && rating.review!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              rating.review!,
              style: const TextStyle(
                color: Color(0xFF4B454A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
