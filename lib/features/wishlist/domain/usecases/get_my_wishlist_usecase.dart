import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

final getMyWishlistUsecaseProvider = Provider<GetMyWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return GetMyWishlistUsecase(wishlistRepository: wishlistRepository);
});

class GetMyWishlistUsecase implements UsecaseWithoutParams<WishlistEntity> {
  final IWishlistRepository _wishlistRepository;

  GetMyWishlistUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call() {
    return _wishlistRepository.getMyWishlist();
  }
}
