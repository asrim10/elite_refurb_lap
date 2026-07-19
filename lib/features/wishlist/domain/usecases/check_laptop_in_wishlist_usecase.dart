import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/wishlist/data/repositories/wishlist_repository.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

class CheckLaptopInWishlistParams extends Equatable {
  final String laptopId;

  const CheckLaptopInWishlistParams({required this.laptopId});

  @override
  List<Object?> get props => [laptopId];
}

final checkLaptopInWishlistUsecaseProvider =
    Provider<CheckLaptopInWishlistUsecase>((ref) {
  final wishlistRepository = ref.read(wishlistRepositoryProvider);
  return CheckLaptopInWishlistUsecase(wishlistRepository: wishlistRepository);
});

class CheckLaptopInWishlistUsecase
    implements UsecaseWithParams<bool, CheckLaptopInWishlistParams> {
  final IWishlistRepository _wishlistRepository;

  CheckLaptopInWishlistUsecase(
      {required IWishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository;

  @override
  Future<Either<Failure, bool>> call(CheckLaptopInWishlistParams params) {
    return _wishlistRepository.checkLaptopInWishlist(params.laptopId);
  }
}
