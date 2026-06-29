import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

class GetPublicWishlistParams extends Equatable {
  final String userId;

  const GetPublicWishlistParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getPublicWishlistUsecaseProvider = Provider<GetPublicWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return GetPublicWishlistUsecase(wishlistRepository: wishlistRepository);
});

class GetPublicWishlistUsecase
    implements UsecaseWithParams<WishlistEntity, GetPublicWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  GetPublicWishlistUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call(GetPublicWishlistParams params) {
    return _wishlistRepository.getPublicWishlist(params.userId);
  }
}
