import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/get_my_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/add_laptop_to_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/remove_laptop_from_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/create_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/update_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/delete_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/clear_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/get_public_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/get_all_public_wishlists_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/domain/usecases/check_laptop_in_wishlist_usecase.dart';
import 'package:EliteReurbLap/features/wishlist/presentation/state/wishlist_state.dart';

final wishlistViewModelProvider =
    NotifierProvider<WishlistViewModel, WishlistState>(
  () => WishlistViewModel(),
);

class WishlistViewModel extends Notifier<WishlistState> {
  late final GetMyWishlistUsecase _getMyWishlistUsecase;
  late final AddLaptopToWishlistUsecase _addLaptopToWishlistUsecase;
  late final RemoveLaptopFromWishlistUsecase _removeLaptopFromWishlistUsecase;
  late final CreateWishlistUsecase _createWishlistUsecase;
  late final UpdateWishlistUsecase _updateWishlistUsecase;
  late final DeleteWishlistUsecase _deleteWishlistUsecase;
  late final ClearWishlistUsecase _clearWishlistUsecase;
  late final GetPublicWishlistUsecase _getPublicWishlistUsecase;
  late final GetAllPublicWishlistsUsecase _getAllPublicWishlistsUsecase;
  late final CheckLaptopInWishlistUsecase _checkLaptopInWishlistUsecase;

  @override
  WishlistState build() {
    _getMyWishlistUsecase = ref.read(getMyWishlistUsecaseProvider);
    _addLaptopToWishlistUsecase = ref.read(addLaptopToWishlistUsecaseProvider);
    _removeLaptopFromWishlistUsecase =
        ref.read(removeLaptopFromWishlistUsecaseProvider);
    _createWishlistUsecase = ref.read(createWishlistUsecaseProvider);
    _updateWishlistUsecase = ref.read(updateWishlistUsecaseProvider);
    _deleteWishlistUsecase = ref.read(deleteWishlistUsecaseProvider);
    _clearWishlistUsecase = ref.read(clearWishlistUsecaseProvider);
    _getPublicWishlistUsecase = ref.read(getPublicWishlistUsecaseProvider);
    _getAllPublicWishlistsUsecase =
        ref.read(getAllPublicWishlistsUsecaseProvider);
    _checkLaptopInWishlistUsecase =
        ref.read(checkLaptopInWishlistUsecaseProvider);
    return const WishlistState();
  }

  Future<void> getMyWishlist() async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _getMyWishlistUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.loaded,
        wishlist: wishlist,
        laptopIds: wishlist.laptopIds,
      ),
    );
  }

  Future<void> addLaptop(String laptopId) async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _addLaptopToWishlistUsecase(
      AddLaptopToWishlistParams(laptopId: laptopId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.laptopAdded,
        wishlist: wishlist,
        laptopIds: wishlist.laptopIds,
        isInWishlist: true,
      ),
    );
  }

  Future<void> removeLaptop(String laptopId) async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _removeLaptopFromWishlistUsecase(
      RemoveLaptopFromWishlistParams(laptopId: laptopId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.laptopRemoved,
        wishlist: wishlist,
        laptopIds: wishlist.laptopIds,
        isInWishlist: false,
      ),
    );
  }

  Future<void> createWishlist({
    String? name,
    String? description,
  }) async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _createWishlistUsecase(
      CreateWishlistParams(name: name, description: description),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.created,
        wishlist: wishlist,
        laptopIds: wishlist.laptopIds,
      ),
    );
  }

  Future<void> updateWishlist({
    String? name,
    String? description,
  }) async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _updateWishlistUsecase(
      UpdateWishlistParams(name: name, description: description),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.updated,
        wishlist: wishlist,
      ),
    );
  }

  Future<void> deleteWishlist() async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _deleteWishlistUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: WishlistStatus.deleted,
        wishlist: null,
        laptopIds: [],
        isInWishlist: false,
      ),
    );
  }

  Future<void> clearWishlist() async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _clearWishlistUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: WishlistStatus.cleared,
        wishlist: state.wishlist != null
            ? WishlistEntity(
                userId: state.wishlist!.userId,
                laptopIds: [],
                name: state.wishlist!.name,
                description: state.wishlist!.description,
              )
            : null,
        laptopIds: [],
        isInWishlist: false,
      ),
    );
  }

  Future<void> getPublicWishlist(String userId) async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _getPublicWishlistUsecase(
      GetPublicWishlistParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (wishlist) => state = state.copyWith(
        status: WishlistStatus.loaded,
        wishlist: wishlist,
        laptopIds: wishlist.laptopIds,
      ),
    );
  }

  Future<void> getAllPublicWishlists() async {
    state = state.copyWith(status: WishlistStatus.loading);

    final result = await _getAllPublicWishlistsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: WishlistStatus.error,
        errorMessage: failure.message,
      ),
      (publicWishlists) => state = state.copyWith(
        status: WishlistStatus.loaded,
        publicWishlists: publicWishlists,
      ),
    );
  }

  Future<void> checkLaptopInWishlist(String laptopId) async {
    final result = await _checkLaptopInWishlistUsecase(
      CheckLaptopInWishlistParams(laptopId: laptopId),
    );

    result.fold(
      (failure) => null,
      (isInWishlist) => state = state.copyWith(isInWishlist: isInWishlist),
    );
  }

  void toggleLaptopInWishlist(String laptopId) {
    if (state.isInWishlist) {
      removeLaptop(laptopId);
    } else {
      addLaptop(laptopId);
    }
  }
}
