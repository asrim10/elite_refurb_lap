import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/rating/data/repositories/rating_repository.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';
import 'package:EliteReurbLap/features/rating/domain/repositories/rating_repository.dart';

class CreateRatingParams extends Equatable {
  final String ratedSellerId;
  final int rating;
  final String? review;

  const CreateRatingParams({
    required this.ratedSellerId,
    required this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [ratedSellerId, rating, review];
}

final createRatingUsecaseProvider = Provider<CreateRatingUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return CreateRatingUsecase(ratingRepository: ratingRepository);
});

class CreateRatingUsecase
    implements UsecaseWithParams<RatingEntity, CreateRatingParams> {
  final IRatingRepository _ratingRepository;

  CreateRatingUsecase({required IRatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, RatingEntity>> call(CreateRatingParams params) {
    return _ratingRepository.createRating(
      ratedSellerId: params.ratedSellerId,
      rating: params.rating,
      review: params.review,
    );
  }
}
