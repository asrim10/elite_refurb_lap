import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/rating/data/datasources/rating_datasource.dart';
import 'package:EliteReurbLap/features/rating/data/datasources/remote/rating_remote_datasource.dart';
import 'package:EliteReurbLap/features/rating/domain/entities/rating_entity.dart';
import 'package:EliteReurbLap/features/rating/domain/repositories/rating_repository.dart';

final ratingRepositoryProvider = Provider<IRatingRepository>((ref) {
  return RatingRepository(
    ratingRemoteDatasource: ref.read(ratingRemoteDatasourceProvider),
  );
});

class RatingRepository implements IRatingRepository {
  final IRatingRemoteDataSource _ratingRemoteDataSource;

  RatingRepository({
    required IRatingRemoteDataSource ratingRemoteDatasource,
  }) : _ratingRemoteDataSource = ratingRemoteDatasource;

  String _extractErrorMessage(DioException e, String fallback) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return (data['message'] as String?) ?? fallback;
      }
      if (data is String && data.isNotEmpty) {
        final cleaned = data.replaceAll(RegExp(r'<[^>]*>'), '').trim();
        return cleaned.isNotEmpty ? cleaned : fallback;
      }
    } catch (_) {}
    return fallback;
  }

  @override
  Future<Either<Failure, RatingEntity>> createRating({
    required String ratedSellerId,
    required int rating,
    String? review,
  }) async {
    try {
      final model = await _ratingRemoteDataSource.createRating(
        ratedSellerId: ratedSellerId,
        rating: rating,
        review: review,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractErrorMessage(e, 'Failed to submit rating'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SellerRatingStats>> getSellerRatings(
      String sellerId) async {
    try {
      final response = await _ratingRemoteDataSource.getSellerRatings(sellerId);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractErrorMessage(e, 'Failed to fetch seller ratings'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingEntity>> updateRating({
    required String ratingId,
    int? rating,
    String? review,
  }) async {
    try {
      final model = await _ratingRemoteDataSource.updateRating(
        ratingId: ratingId,
        rating: rating,
        review: review,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractErrorMessage(e, 'Failed to update rating'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRating(String ratingId) async {
    try {
      await _ratingRemoteDataSource.deleteRating(ratingId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractErrorMessage(e, 'Failed to delete rating'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
