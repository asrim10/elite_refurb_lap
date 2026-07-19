import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/features/rating/domain/usecases/create_rating_usecase.dart';
import 'package:EliteReurbLap/features/rating/domain/usecases/get_seller_ratings_usecase.dart';
import 'package:EliteReurbLap/features/rating/domain/usecases/update_rating_usecase.dart';
import 'package:EliteReurbLap/features/rating/domain/usecases/delete_rating_usecase.dart';
import 'package:EliteReurbLap/features/rating/presentation/state/rating_state.dart';

final ratingViewModelProvider =
    NotifierProvider<RatingViewModel, RatingState>(
  () => RatingViewModel(),
);

class RatingViewModel extends Notifier<RatingState> {
  late final CreateRatingUsecase _createRatingUsecase;
  late final GetSellerRatingsUsecase _getSellerRatingsUsecase;
  late final UpdateRatingUsecase _updateRatingUsecase;
  late final DeleteRatingUsecase _deleteRatingUsecase;

  @override
  RatingState build() {
    _createRatingUsecase = ref.read(createRatingUsecaseProvider);
    _getSellerRatingsUsecase = ref.read(getSellerRatingsUsecaseProvider);
    _updateRatingUsecase = ref.read(updateRatingUsecaseProvider);
    _deleteRatingUsecase = ref.read(deleteRatingUsecaseProvider);
    return const RatingState();
  }

  Future<void> getSellerRatings(String sellerId) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _getSellerRatingsUsecase(
      GetSellerRatingsParams(sellerId: sellerId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (stats) => state = state.copyWith(
        status: RatingStatus.loaded,
        sellerStats: stats,
      ),
    );
  }

  Future<void> createRating({
    required String ratedSellerId,
    required int rating,
    String? review,
  }) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _createRatingUsecase(
      CreateRatingParams(
        ratedSellerId: ratedSellerId,
        rating: rating,
        review: review,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (ratingEntity) => state = state.copyWith(
        status: RatingStatus.created,
        createdRating: ratingEntity,
      ),
    );
  }

  Future<void> updateRating({
    required String ratingId,
    int? rating,
    String? review,
  }) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _updateRatingUsecase(
      UpdateRatingParams(
        ratingId: ratingId,
        rating: rating,
        review: review,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: RatingStatus.updated,
      ),
    );
  }

  Future<void> deleteRating(String ratingId) async {
    state = state.copyWith(status: RatingStatus.loading);

    final result = await _deleteRatingUsecase(
      DeleteRatingParams(ratingId: ratingId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: RatingStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: RatingStatus.deleted,
      ),
    );
  }
}
