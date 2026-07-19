import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/rating/data/repositories/rating_repository.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';
import 'package:EliteReurbLap/features/rating/domain/repositories/rating_repository.dart';

class GetSellerRatingsParams extends Equatable {
  final String sellerId;

  const GetSellerRatingsParams({required this.sellerId});

  @override
  List<Object?> get props => [sellerId];
}

final getSellerRatingsUsecaseProvider =
    Provider<GetSellerRatingsUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return GetSellerRatingsUsecase(ratingRepository: ratingRepository);
});

class GetSellerRatingsUsecase
    implements UsecaseWithParams<SellerRatingStats, GetSellerRatingsParams> {
  final IRatingRepository _ratingRepository;

  GetSellerRatingsUsecase({required IRatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, SellerRatingStats>> call(
      GetSellerRatingsParams params) {
    return _ratingRepository.getSellerRatings(params.sellerId);
  }
}
