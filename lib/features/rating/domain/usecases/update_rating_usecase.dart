import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/rating/data/repositories/rating_repository.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';
import 'package:EliteReurbLap/features/rating/domain/repositories/rating_repository.dart';

class UpdateRatingParams extends Equatable {
  final String ratingId;
  final int? rating;
  final String? review;

  const UpdateRatingParams({
    required this.ratingId,
    this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [ratingId, rating, review];
}

final updateRatingUsecaseProvider = Provider<UpdateRatingUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return UpdateRatingUsecase(ratingRepository: ratingRepository);
});

class UpdateRatingUsecase
    implements UsecaseWithParams<RatingEntity, UpdateRatingParams> {
  final IRatingRepository _ratingRepository;

  UpdateRatingUsecase({required IRatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, RatingEntity>> call(UpdateRatingParams params) {
    return _ratingRepository.updateRating(
      ratingId: params.ratingId,
      rating: params.rating,
      review: params.review,
    );
  }
}
