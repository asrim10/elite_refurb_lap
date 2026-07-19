import 'package:EliteReurbLap/features/rating/data/models/rating_model.dart';

abstract interface class IRatingRemoteDataSource {
  Future<RatingModel> createRating({
    required String ratedSellerId,
    required int rating,
    String? review,
  });

  Future<SellerRatingStatsResponse> getSellerRatings(String sellerId);

  Future<RatingModel> updateRating({
    required String ratingId,
    int? rating,
    String? review,
  });

  Future<void> deleteRating(String ratingId);
}
