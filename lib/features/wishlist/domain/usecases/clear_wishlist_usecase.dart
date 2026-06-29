import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

final clearWishlistUsecaseProvider = Provider<ClearWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return ClearWishlistUsecase(wishlistRepository: wishlistRepository);
});

class ClearWishlistUsecase implements UsecaseWithoutParams<void> {
  final IWishlistRepository _wishlistRepository;

  ClearWishlistUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _wishlistRepository.clear();
  }
}
