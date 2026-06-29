import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';

part 'wishlist_model.g.dart';

@JsonSerializable()
class WishlistModel {
  final String userId;
  final List<String> laptopIds;
  final String? name;
  final String? description;

  WishlistModel({
    required this.userId,
    this.laptopIds = const [],
    this.name,
    this.description,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistModelToJson(this);

  WishlistEntity toEntity() {
    return WishlistEntity(
      userId: userId,
      laptopIds: laptopIds,
      name: name,
      description: description,
    );
  }

  factory WishlistModel.fromEntity(WishlistEntity entity) {
    return WishlistModel(
      userId: entity.userId,
      laptopIds: entity.laptopIds,
      name: entity.name,
      description: entity.description,
    );
  }

  static List<WishlistEntity> toEntityList(List<WishlistModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
