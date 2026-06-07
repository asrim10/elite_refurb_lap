import 'package:equatable/equatable.dart';

class LaptopEntity extends Equatable {
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
  final LaptopLocationEntity? location;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LaptopEntity({
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

  @override
  List<Object?> get props => [
        id,
        title,
        brand,
        modelName,
        price,
        originalPrice,
        condition,
        status,
        description,
        images,
        processor,
        ram,
        storage,
        storageType,
        displaySize,
        displayResolution,
        gpu,
        operatingSystem,
        batteryLife,
        weight,
        sellerId,
        sellerName,
        yearOfManufacture,
        warrantyMonths,
        location,
        tags,
        createdAt,
        updatedAt,
      ];
}

class LaptopLocationEntity extends Equatable {
  final double lat;
  final double lng;
  final String? address;

  const LaptopLocationEntity({
    required this.lat,
    required this.lng,
    this.address,
  });

  @override
  List<Object?> get props => [lat, lng, address];
}
