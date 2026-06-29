import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:equatable/equatable.dart';

enum WishlistStatus {
  initial,
  loading,
  loaded,
  created,
  updated,
  deleted,
  laptopAdded,
  laptopRemoved,
  cleared,
  error,
}

class WishlistState extends Equatable {
  final WishlistStatus status;
  final WishlistEntity? wishlist;
  final List<WishlistEntity> publicWishlists;
  final List<String> laptopIds;
  final bool isInWishlist;
  final String? errorMessage;

  const WishlistState({
    this.status = WishlistStatus.initial,
    this.wishlist,
    this.publicWishlists = const [],
    this.laptopIds = const [],
    this.isInWishlist = false,
    this.errorMessage,
  });

  WishlistState copyWith({
    WishlistStatus? status,
    WishlistEntity? wishlist,
    List<WishlistEntity>? publicWishlists,
    List<String>? laptopIds,
    bool? isInWishlist,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      wishlist: wishlist ?? this.wishlist,
      publicWishlists: publicWishlists ?? this.publicWishlists,
      laptopIds: laptopIds ?? this.laptopIds,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        wishlist,
        publicWishlists,
        laptopIds,
        isInWishlist,
        errorMessage,
      ];
}
