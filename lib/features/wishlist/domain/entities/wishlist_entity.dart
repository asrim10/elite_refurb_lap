import 'package:equatable/equatable.dart';

class WishlistEntity extends Equatable {
  final String userId;
  final List<String> laptopIds;
  final String? name;
  final String? description;

  const WishlistEntity({
    required this.userId,
    this.laptopIds = const [],
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [
        userId,
        laptopIds,
        name,
        description,
      ];
}
