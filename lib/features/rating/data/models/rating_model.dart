import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';

part 'rating_model.g.dart';

@JsonSerializable(createFactory: false)
class RatingModel {
  @JsonKey(name: '_id')
  final String id;
  final String ratedSellerId;
  final String ratedByUserId;
  final String? ratedByUserFullName;
  final String? ratedByUserImageUrl;
  final int rating;
  final String? review;
  final String? createdAt;
  final String? updatedAt;

  RatingModel({
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

  /// Custom factory that handles both populated (object) and
  /// unpopulated (string) [ratedByUserId] from the backend.
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    // Extract ratedByUserId – could be a plain string or a populated object
    String userId;
    String? userName;
    String? userImage;
    final ratedBy = json['ratedByUserId'];
    if (ratedBy is Map<String, dynamic>) {
      userId = ratedBy['_id'] as String? ?? '';
      userName = ratedBy['fullName'] as String?;
      userImage = ratedBy['imageUrl'] as String?;
    } else {
      userId = (ratedBy as String?) ?? '';
    }

    return RatingModel(
      id: json['_id'] as String? ?? '',
      ratedSellerId: json['ratedSellerId'] as String? ?? '',
      ratedByUserId: userId,
      ratedByUserFullName: userName,
      ratedByUserImageUrl: userImage,
      rating: json['rating'] as int? ?? 0,
      review: json['review'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);

  RatingEntity toEntity() {
    return RatingEntity(
      id: id,
      ratedSellerId: ratedSellerId,
      ratedByUserId: ratedByUserId,
      ratedByUserFullName: ratedByUserFullName,
      ratedByUserImageUrl: ratedByUserImageUrl,
      rating: rating,
      review: review,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  factory RatingModel.fromEntity(RatingEntity entity) {
    return RatingModel(
      id: entity.id,
      ratedSellerId: entity.ratedSellerId,
      ratedByUserId: entity.ratedByUserId,
      ratedByUserFullName: entity.ratedByUserFullName,
      ratedByUserImageUrl: entity.ratedByUserImageUrl,
      rating: entity.rating,
      review: entity.review,
    );
  }
}

/// Helper to parse seller rating stats response from the backend.
class SellerRatingStatsResponse {
  final List<RatingModel> ratings;
  final double averageRating;
  final int totalRatings;

  SellerRatingStatsResponse({
    required this.ratings,
    required this.averageRating,
    required this.totalRatings,
  });

  factory SellerRatingStatsResponse.fromJson(Map<String, dynamic> json) {
    return SellerRatingStatsResponse(
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
    );
  }

  SellerRatingStats toEntity() {
    return SellerRatingStats(
      ratings: ratings.map((r) => r.toEntity()).toList(),
      averageRating: averageRating,
      totalRatings: totalRatings,
    );
  }
}
