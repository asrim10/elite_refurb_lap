import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ILaptopRepository {
  Future<Either<Failure, List<LaptopEntity>>> getAll({
    Map<String, dynamic>? queryParameters,
  });
  Future<Either<Failure, LaptopEntity>> getById(String id);
  Future<Either<Failure, List<LaptopEntity>>> getMyListings();
  Future<Either<Failure, List<LaptopEntity>>> getSellerListings(
    String sellerId,
  );
  Future<Either<Failure, LaptopEntity>> create(LaptopEntity laptop);
  Future<Either<Failure, LaptopEntity>> update(
    String id,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> delete(String id);
}
