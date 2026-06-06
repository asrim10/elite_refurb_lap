import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/laptop/data/datasources/laptop_datasource.dart';
import 'package:EliteReurbLap/features/laptop/data/models/laptop_api_model.dart';

final laptopRemoteDatasourceProvider = Provider<ILaptopRemoteDataSource>((ref) {
  return LaptopRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class LaptopRemoteDatasource implements ILaptopRemoteDataSource {
  final ApiClient _apiClient;

  LaptopRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<List<LaptopApiModel>> getAll({
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.laptops,
      queryParameters: queryParameters,
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LaptopApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LaptopApiModel> getById(String id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.laptopById}$id',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return LaptopApiModel.fromJson(data);
  }

  @override
  Future<List<LaptopApiModel>> getMyListings() async {
    final response = await _apiClient.get(
      ApiEndpoints.laptopMyListings,
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LaptopApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<LaptopApiModel>> getSellerListings(String sellerId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.laptopBySeller}$sellerId',
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => LaptopApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<LaptopApiModel> create({
    required LaptopApiModel laptop,
    required List<MultipartFile> images,
  }) async {
    final formData = FormData.fromMap({
      ...laptop.toJson(),
      if (images.isNotEmpty) 'images': images,
    });

    final response = await _apiClient.dio.post(
      ApiEndpoints.laptops,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return LaptopApiModel.fromJson(data);
  }

  @override
  Future<LaptopApiModel> update({
    required String id,
    required Map<String, dynamic> data,
    List<MultipartFile>? images,
  }) async {
    final formData = FormData.fromMap({
      ...data,
      if (images != null && images.isNotEmpty) 'images': images,
    });

    final response = await _apiClient.dio.patch(
      '${ApiEndpoints.laptopById}$id',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final result = response.data['data'] as Map<String, dynamic>;
    return LaptopApiModel.fromJson(result);
  }

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete(
      '${ApiEndpoints.laptopById}$id',
    );
  }
}
