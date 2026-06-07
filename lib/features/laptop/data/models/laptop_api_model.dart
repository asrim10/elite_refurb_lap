import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';

part 'laptop_api_model.g.dart';

@JsonSerializable()
class LaptopLocationApiModel {
  final double lat;
  final double lng;
  final String? address;

  LaptopLocationApiModel({
    required this.lat,
    required this.lng,
    this.address,
  });

  factory LaptopLocationApiModel.fromJson(Map<String, dynamic> json) =>
      _$LaptopLocationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaptopLocationApiModelToJson(this);

  LaptopLocationEntity toEntity() {
    return LaptopLocationEntity(
      lat: lat,
      lng: lng,
      address: address,
    );
  }

  factory LaptopLocationApiModel.fromEntity(LaptopLocationEntity entity) {
    return LaptopLocationApiModel(
      lat: entity.lat,
      lng: entity.lng,
      address: entity.address,
    );
  }
}

@JsonSerializable()
class LaptopApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String brand;
  final String modelName;
  final double price;
  final double? originalPrice;
  final String condition;
  final String status;
  final String? description;
  final List<String> images;
  final String processor;
  final int ram;
  final int storage;
  final String storageType;
  final double displaySize;
  final String? displayResolution;
  final String? gpu;
  final String? operatingSystem;
  final double? batteryLife;
  final double? weight;
  final String? sellerId;
  final String? sellerName;
  final int? yearOfManufacture;
  final int? warrantyMonths;
  final LaptopLocationApiModel? location;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LaptopApiModel({
    this.id,
    required this.title,
    required this.brand,
    required this.modelName,
    required this.price,
    this.originalPrice,
    this.condition = 'excellent',
    this.status = 'available',
    this.description,
    this.images = const [],
    required this.processor,
    required this.ram,
    required this.storage,
    this.storageType = 'SSD',
    required this.displaySize,
    this.displayResolution,
    this.gpu,
    this.operatingSystem,
    this.batteryLife,
    this.weight,
    this.sellerId,
    this.sellerName,
    this.yearOfManufacture,
    this.warrantyMonths,
    this.location,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory LaptopApiModel.fromJson(Map<String, dynamic> json) =>
      _$LaptopApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaptopApiModelToJson(this);

  LaptopEntity toEntity() {
    return LaptopEntity(
      id: id,
      title: title,
      brand: brand,
      modelName: modelName,
      price: price,
      originalPrice: originalPrice,
      condition: condition,
      status: status,
      description: description,
      images: images,
      processor: processor,
      ram: ram,
      storage: storage,
      storageType: storageType,
      displaySize: displaySize,
      displayResolution: displayResolution,
      gpu: gpu,
      operatingSystem: operatingSystem,
      batteryLife: batteryLife,
      weight: weight,
      sellerId: sellerId,
      sellerName: sellerName,
      yearOfManufacture: yearOfManufacture,
      warrantyMonths: warrantyMonths,
      location: location?.toEntity(),
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory LaptopApiModel.fromEntity(LaptopEntity entity) {
    return LaptopApiModel(
      id: entity.id,
      title: entity.title,
      brand: entity.brand,
      modelName: entity.modelName,
      price: entity.price,
      originalPrice: entity.originalPrice,
      condition: entity.condition,
      status: entity.status,
      description: entity.description,
      images: entity.images,
      processor: entity.processor,
      ram: entity.ram,
      storage: entity.storage,
      storageType: entity.storageType,
      displaySize: entity.displaySize,
      displayResolution: entity.displayResolution,
      gpu: entity.gpu,
      operatingSystem: entity.operatingSystem,
      batteryLife: entity.batteryLife,
      weight: entity.weight,
      sellerId: entity.sellerId,
      sellerName: entity.sellerName,
      yearOfManufacture: entity.yearOfManufacture,
      warrantyMonths: entity.warrantyMonths,
      location: entity.location != null
          ? LaptopLocationApiModel.fromEntity(entity.location!)
          : null,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<LaptopEntity> toEntityList(List<LaptopApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
