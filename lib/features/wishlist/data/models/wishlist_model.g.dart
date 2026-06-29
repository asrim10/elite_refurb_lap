// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) =>
    WishlistModel(
      userId: json['userId'] as String,
      laptopIds: (json['laptopIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$WishlistModelToJson(WishlistModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'laptopIds': instance.laptopIds,
      'name': instance.name,
      'description': instance.description,
    };
