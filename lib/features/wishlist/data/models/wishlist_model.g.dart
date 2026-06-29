// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) =>
    WishlistModel(
      userId: json['userId'] as String,
      laptopIds: json['laptopIds'] == null
          ? const []
          : WishlistModel._laptopIdsFromJson(json['laptopIds'] as List),
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$WishlistModelToJson(WishlistModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'laptopIds': WishlistModel._laptopIdsToJson(instance.laptopIds),
      'name': instance.name,
      'description': instance.description,
    };
