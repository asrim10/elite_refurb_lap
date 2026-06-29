import 'package:EliteReurbLap/features/wishlist/data/models/wishlist_model.dart';

abstract interface class IWishlistRemoteDataSource {
  // Public routes
  Future<List<WishlistModel>> getAllPublicWishlists();
  Future<WishlistModel> getPublicWishlist(String userId);

  // Protected routes
  Future<WishlistModel> create({
    String? name,
    String? description,
  });
  Future<WishlistModel> getMyWishlist();
  Future<WishlistModel> addLaptop(String laptopId);
  Future<WishlistModel> removeLaptop(String laptopId);
  Future<void> clear();
  Future<WishlistModel> update({
    String? name,
    String? description,
  });
  Future<void> delete();
  Future<bool> checkLaptopInWishlist(String laptopId);
}
