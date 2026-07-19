import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final String id;
  final String ratedSellerId;
  final String ratedByUserId;
  final String? ratedByUserFullName;
  final String? ratedByUserImageUrl;
  final int rating;
  final String? review;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RatingEntity({
    required this.id,
    required this.ratedSellerId,
    required this.ratedByUserId,
    this.ratedByUserFullName,
    this.ratedByUserImageUrl,
    required this.rating,
    this.review,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        ratedSellerId,
        ratedByUserId,
        ratedByUserFullName,
        ratedByUserImageUrl,
        rating,
        review,
        createdAt,
        updatedAt,
      ];
}

class SellerRatingStats extends Equatable {
  final List<RatingEntity> ratings;
  final double averageRating;
  final int totalRatings;

  const SellerRatingStats({
    this.ratings = const [],
    this.averageRating = 0.0,
    this.totalRatings = 0,
  });

  @override
  List<Object?> get props => [ratings, averageRating, totalRatings];
}
