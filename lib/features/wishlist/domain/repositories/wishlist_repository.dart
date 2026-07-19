import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IWishlistRepository {
  // Public routes
  Future<Either<Failure, List<WishlistEntity>>> getAllPublicWishlists();
  Future<Either<Failure, WishlistEntity>> getPublicWishlist(String userId);

  // Protected routes
  Future<Either<Failure, WishlistEntity>> create({
    String? name,
    String? description,
  });
  Future<Either<Failure, WishlistEntity>> getMyWishlist();
  Future<Either<Failure, WishlistEntity>> addLaptop(String laptopId);
  Future<Either<Failure, WishlistEntity>> removeLaptop(String laptopId);
  Future<Either<Failure, void>> clear();
  Future<Either<Failure, WishlistEntity>> update({
    String? name,
    String? description,
  });
  Future<Either<Failure, void>> delete();
  Future<Either<Failure, bool>> checkLaptopInWishlist(String laptopId);
}
