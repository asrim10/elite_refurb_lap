import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/rating/data/datasources/rating_datasource.dart';
import 'package:EliteReurbLap/features/rating/data/models/rating_model.dart';

final ratingRemoteDatasourceProvider = Provider<IRatingRemoteDataSource>((ref) {
  return RatingRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class RatingRemoteDatasource implements IRatingRemoteDataSource {
  final ApiClient _apiClient;

  RatingRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<RatingModel> createRating({
    required String ratedSellerId,
    required int rating,
    String? review,
  }) async {
    final body = <String, dynamic>{
      'ratedSellerId': ratedSellerId,
      'rating': rating,
    };
    if (review != null && review.trim().isNotEmpty) {
      body['review'] = review.trim();
    }

    final response = await _apiClient.post(
      ApiEndpoints.ratings,
      data: body,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return RatingModel.fromJson(data);
  }

  @override
  Future<SellerRatingStatsResponse> getSellerRatings(String sellerId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.ratingBySeller}$sellerId',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return SellerRatingStatsResponse.fromJson(data);
  }

  @override
  Future<RatingModel> updateRating({
    required String ratingId,
    int? rating,
    String? review,
  }) async {
    final body = <String, dynamic>{};
    if (rating != null) body['rating'] = rating;
    if (review != null) body['review'] = review;

    final response = await _apiClient.patch(
      '${ApiEndpoints.ratingById}$ratingId',
      data: body,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return RatingModel.fromJson(data);
  }

  @override
  Future<void> deleteRating(String ratingId) async {
    await _apiClient.delete(
      '${ApiEndpoints.ratingById}$ratingId',
    );
  }
}
