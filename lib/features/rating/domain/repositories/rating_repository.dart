import 'package:dartz/dartz.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';

abstract interface class IRatingRepository {
  Future<Either<Failure, RatingEntity>> createRating({
    required String ratedSellerId,
    required int rating,
    String? review,
  });

  Future<Either<Failure, SellerRatingStats>> getSellerRatings(String sellerId);

  Future<Either<Failure, RatingEntity>> updateRating({
    required String ratingId,
    int? rating,
    String? review,
  });

  Future<Either<Failure, void>> deleteRating(String ratingId);
}
