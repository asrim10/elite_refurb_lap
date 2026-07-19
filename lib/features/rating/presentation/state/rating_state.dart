import 'package:equatable/equatable.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';

enum RatingStatus {
  initial,
  loading,
  loaded,
  created,
  updated,
  deleted,
  error,
}

class RatingState extends Equatable {
  final RatingStatus status;
  final SellerRatingStats? sellerStats;
  final RatingEntity? createdRating;
  final String? errorMessage;

  const RatingState({
    this.status = RatingStatus.initial,
    this.sellerStats,
    this.createdRating,
    this.errorMessage,
  });

  RatingState copyWith({
    RatingStatus? status,
    SellerRatingStats? sellerStats,
    RatingEntity? createdRating,
    String? errorMessage,
  }) {
    return RatingState(
      status: status ?? this.status,
      sellerStats: sellerStats ?? this.sellerStats,
      createdRating: createdRating ?? this.createdRating,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sellerStats,
        createdRating,
        errorMessage,
      ];
}
