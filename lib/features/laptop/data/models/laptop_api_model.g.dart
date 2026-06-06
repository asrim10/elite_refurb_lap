// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laptop_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaptopLocationApiModel _$LaptopLocationApiModelFromJson(
        Map<String, dynamic> json) =>
    LaptopLocationApiModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$LaptopLocationApiModelToJson(
        LaptopLocationApiModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
    };

LaptopApiModel _$LaptopApiModelFromJson(Map<String, dynamic> json) =>
    LaptopApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      brand: json['brand'] as String,
      modelName: json['modelName'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      condition: json['condition'] as String? ?? 'excellent',
      status: json['status'] as String? ?? 'available',
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      processor: json['processor'] as String,
      ram: (json['ram'] as num).toInt(),
      storage: (json['storage'] as num).toInt(),
      storageType: json['storageType'] as String? ?? 'SSD',
      displaySize: (json['displaySize'] as num).toDouble(),
      displayResolution: json['displayResolution'] as String?,
      gpu: json['gpu'] as String?,
      operatingSystem: json['operatingSystem'] as String?,
      batteryLife: (json['batteryLife'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      sellerId: json['sellerId'] as String?,
      sellerName: json['sellerName'] as String?,
      yearOfManufacture: (json['yearOfManufacture'] as num?)?.toInt(),
      warrantyMonths: (json['warrantyMonths'] as num?)?.toInt(),
      location: json['location'] == null
          ? null
          : LaptopLocationApiModel.fromJson(
              json['location'] as Map<String, dynamic>),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LaptopApiModelToJson(LaptopApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'brand': instance.brand,
      'modelName': instance.modelName,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'condition': instance.condition,
      'status': instance.status,
      'description': instance.description,
      'images': instance.images,
      'processor': instance.processor,
      'ram': instance.ram,
      'storage': instance.storage,
      'storageType': instance.storageType,
      'displaySize': instance.displaySize,
      'displayResolution': instance.displayResolution,
      'gpu': instance.gpu,
      'operatingSystem': instance.operatingSystem,
      'batteryLife': instance.batteryLife,
      'weight': instance.weight,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'yearOfManufacture': instance.yearOfManufacture,
      'warrantyMonths': instance.warrantyMonths,
      'location': instance.location,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
