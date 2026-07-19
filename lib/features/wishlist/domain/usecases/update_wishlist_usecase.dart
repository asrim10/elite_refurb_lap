import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

class UpdateWishlistParams extends Equatable {
  final String? name;
  final String? description;

  const UpdateWishlistParams({this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

final updateWishlistUsecaseProvider = Provider<UpdateWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return UpdateWishlistUsecase(wishlistRepository: wishlistRepository);
});

class UpdateWishlistUsecase
    implements UsecaseWithParams<WishlistEntity, UpdateWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  UpdateWishlistUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call(UpdateWishlistParams params) {
    return _wishlistRepository.update(
      name: params.name,
      description: params.description,
    );
  }
}
