import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

class RemoveLaptopFromWishlistParams extends Equatable {
  final String laptopId;

  const RemoveLaptopFromWishlistParams({required this.laptopId});

  @override
  List<Object?> get props => [laptopId];
}

final removeLaptopFromWishlistUsecaseProvider =
    Provider<RemoveLaptopFromWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return RemoveLaptopFromWishlistUsecase(
      wishlistRepository: wishlistRepository);
});

class RemoveLaptopFromWishlistUsecase
    implements
        UsecaseWithParams<WishlistEntity, RemoveLaptopFromWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  RemoveLaptopFromWishlistUsecase(
      {required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call(
      RemoveLaptopFromWishlistParams params) {
    return _wishlistRepository.removeLaptop(params.laptopId);
  }
}
