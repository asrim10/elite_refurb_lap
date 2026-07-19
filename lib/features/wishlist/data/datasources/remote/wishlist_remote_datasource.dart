import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:EliteReurbLap/features/wishlist/data/models/wishlist_model.dart';

final wishlistRemoteDatasourceProvider = Provider<IWishlistRemoteDataSource>((ref) {
  return WishlistRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class WishlistRemoteDatasource implements IWishlistRemoteDataSource {
  final ApiClient _apiClient;

  WishlistRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<WishlistModel>> getAllPublicWishlists() async {
    final response = await _apiClient.get(
      ApiEndpoints.wishlistPublic,
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => WishlistModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<WishlistModel> getPublicWishlist(String userId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.wishlistPublicByUser}$userId',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<WishlistModel> create({
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;

    final response = await _apiClient.post(
      ApiEndpoints.wishlist,
      data: body,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<WishlistModel> getMyWishlist() async {
    final response = await _apiClient.get(
      ApiEndpoints.wishlistMy,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<WishlistModel> addLaptop(String laptopId) async {
    final response = await _apiClient.post(
      ApiEndpoints.wishlistAddLaptop,
      data: {'laptopId': laptopId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<WishlistModel> removeLaptop(String laptopId) async {
    final response = await _apiClient.post(
      ApiEndpoints.wishlistRemoveLaptop,
      data: {'laptopId': laptopId},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<void> clear() async {
    await _apiClient.post(
      ApiEndpoints.wishlistClear,
    );
  }

  @override
  Future<WishlistModel> update({
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;

    final response = await _apiClient.patch(
      ApiEndpoints.wishlist,
      data: body,
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return WishlistModel.fromJson(data);
  }

  @override
  Future<void> delete() async {
    await _apiClient.delete(
      ApiEndpoints.wishlist,
    );
  }

  @override
  Future<bool> checkLaptopInWishlist(String laptopId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.wishlistCheckLaptop}$laptopId',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return data['inWishlist'] as bool;
  }
}
