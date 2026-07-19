import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/rating/data/repositories/rating_repository.dart';
import 'package:EliteReurbLap/features/rating/domain/repositories/rating_repository.dart';

class DeleteRatingParams extends Equatable {
  final String ratingId;

  const DeleteRatingParams({required this.ratingId});

  @override
  List<Object?> get props => [ratingId];
}

final deleteRatingUsecaseProvider = Provider<DeleteRatingUsecase>((ref) {
  final ratingRepository = ref.read(ratingRepositoryProvider);
  return DeleteRatingUsecase(ratingRepository: ratingRepository);
});

class DeleteRatingUsecase
    implements UsecaseWithParams<void, DeleteRatingParams> {
  final IRatingRepository _ratingRepository;

  DeleteRatingUsecase({required IRatingRepository ratingRepository})
      : _ratingRepository = ratingRepository;

  @override
  Future<Either<Failure, void>> call(DeleteRatingParams params) {
    return _ratingRepository.deleteRating(params.ratingId);
  }
}
