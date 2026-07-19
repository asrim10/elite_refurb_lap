import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

class CreateWishlistParams extends Equatable {
  final String? name;
  final String? description;

  const CreateWishlistParams({this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

final createWishlistUsecaseProvider = Provider<CreateWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return CreateWishlistUsecase(wishlistRepository: wishlistRepository);
});

class CreateWishlistUsecase
    implements UsecaseWithParams<WishlistEntity, CreateWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  CreateWishlistUsecase({required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, WishlistEntity>> call(CreateWishlistParams params) {
    return _wishlistRepository.create(
      name: params.name,
      description: params.description,
    );
  }
}
