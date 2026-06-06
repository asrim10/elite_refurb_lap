import 'package:dio/dio.dart';
import 'package:EliteReurbLap/features/laptop/data/models/laptop_api_model.dart';

abstract interface class ILaptopRemoteDataSource {
  Future<List<LaptopApiModel>> getAll({
    Map<String, dynamic>? queryParameters,
  });
  Future<LaptopApiModel> getById(String id);
  Future<List<LaptopApiModel>> getMyListings();
  Future<List<LaptopApiModel>> getSellerListings(String sellerId);
  Future<LaptopApiModel> create({
    required LaptopApiModel laptop,
    required List<MultipartFile> images,
  });
  Future<LaptopApiModel> update({
    required String id,
    required Map<String, dynamic> data,
    List<MultipartFile>? images,
  });
  Future<String> uploadImage(MultipartFile image);
  Future<void> delete(String id);
}
