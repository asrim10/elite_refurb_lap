import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/laptop/data/datasources/laptop_datasource.dart';
import 'package:EliteReurbLap/features/laptop/data/datasources/remote/laptop_remote_datasource.dart';
import 'package:EliteReurbLap/features/laptop/data/models/laptop_api_model.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

final laptopRepositoryProvider = Provider<ILaptopRepository>((ref) {
  return LaptopRepository(
    laptopRemoteDatasource: ref.read(laptopRemoteDatasourceProvider),
  );
});

class LaptopRepository implements ILaptopRepository {
  final ILaptopRemoteDataSource _laptopRemoteDataSource;

  LaptopRepository({
    required ILaptopRemoteDataSource laptopRemoteDatasource,
  }) : _laptopRemoteDataSource = laptopRemoteDatasource;

  @override
  Future<Either<Failure, List<LaptopEntity>>> getAll({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final models = await _laptopRemoteDataSource.getAll(
        queryParameters: queryParameters,
      );
      return Right(LaptopApiModel.toEntityList(models));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch laptops',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LaptopEntity>> getById(String id) async {
    try {
      final model = await _laptopRemoteDataSource.getById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch laptop',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LaptopEntity>>> getMyListings() async {
    try {
      final models = await _laptopRemoteDataSource.getMyListings();
      return Right(LaptopApiModel.toEntityList(models));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch your listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LaptopEntity>>> getSellerListings(
    String sellerId,
  ) async {
    try {
      final models =
          await _laptopRemoteDataSource.getSellerListings(sellerId);
      return Right(LaptopApiModel.toEntityList(models));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message'] ?? 'Failed to fetch seller listings',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LaptopEntity>> create(LaptopEntity laptop) async {
    try {
      final apiModel = LaptopApiModel.fromEntity(laptop);
      final model = await _laptopRemoteDataSource.create(
        laptop: apiModel,
        images: [],
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to create listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LaptopEntity>> update(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await _laptopRemoteDataSource.update(
        id: id,
        data: data,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _laptopRemoteDataSource.delete(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to delete listing',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
