import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:EliteReurbLap/features/wishlist/data/datasources/remote/wishlist_remote_datasource.dart';
import 'package:EliteReurbLap/features/wishlist/data/models/wishlist_model.dart';
import 'package:EliteReurbLap/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:EliteReurbLap/features/wishlist/domain/repositories/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  return WishlistRepository(
    wishlistRemoteDatasource: ref.read(wishlistRemoteDatasourceProvider),
  );
});

class WishlistRepository implements IWishlistRepository {
  final IWishlistRemoteDataSource _wishlistRemoteDataSource;

  WishlistRepository({
    required IWishlistRemoteDataSource wishlistRemoteDatasource,
  }) : _wishlistRemoteDataSource = wishlistRemoteDatasource;

  @override
  Future<Either<Failure, List<WishlistEntity>>> getAllPublicWishlists() async {
    try {
      final models = await _wishlistRemoteDataSource.getAllPublicWishlists();
      return Right(WishlistModel.toEntityList(models));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch public wishlists',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> getPublicWishlist(String userId) async {
    try {
      final model = await _wishlistRemoteDataSource.getPublicWishlist(userId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch public wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> create({
    String? name,
    String? description,
  }) async {
    try {
      final model = await _wishlistRemoteDataSource.create(
        name: name,
        description: description,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to create wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> getMyWishlist() async {
    try {
      final model = await _wishlistRemoteDataSource.getMyWishlist();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to fetch your wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> addLaptop(String laptopId) async {
    try {
      final model = await _wishlistRemoteDataSource.addLaptop(laptopId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to add laptop to wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> removeLaptop(String laptopId) async {
    try {
      final model = await _wishlistRemoteDataSource.removeLaptop(laptopId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to remove laptop from wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clear() async {
    try {
      await _wishlistRemoteDataSource.clear();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to clear wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> update({
    String? name,
    String? description,
  }) async {
    try {
      final model = await _wishlistRemoteDataSource.update(
        name: name,
        description: description,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to update wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete() async {
    try {
      await _wishlistRemoteDataSource.delete();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to delete wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLaptopInWishlist(String laptopId) async {
    try {
      final inWishlist = await _wishlistRemoteDataSource.checkLaptopInWishlist(laptopId);
      return Right(inWishlist);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to check laptop in wishlist',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
