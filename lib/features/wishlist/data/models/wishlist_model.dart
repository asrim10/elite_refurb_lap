import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';

part 'wishlist_model.g.dart';

/// Converts a dynamic value (String or Map with _id) to a String ID.
String _laptopIdFromJson(dynamic e) {
  if (e is String) return e;
  if (e is Map) return e['_id'] as String;
  return '';
}

@JsonSerializable()
class WishlistModel {
  final String userId;
  @JsonKey(fromJson: _laptopIdsFromJson, toJson: _laptopIdsToJson)
  final List<String> laptopIds;
  final String? name;
  final String? description;

  WishlistModel({
    required this.userId,
    this.laptopIds = const [],
    this.name,
    this.description,
  });

  static List<String> _laptopIdsFromJson(List<dynamic> json) {
    return json.map((e) => _laptopIdFromJson(e)).toList();
  }

  static List<String> _laptopIdsToJson(List<String> ids) => ids;

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
