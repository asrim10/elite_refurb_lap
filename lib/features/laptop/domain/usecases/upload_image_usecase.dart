import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/datasources/laptop_datasource.dart';
import 'package:EliteReurbLap/features/laptop/data/datasources/remote/laptop_remote_datasource.dart';

class UploadImageParams extends Equatable {
  final MultipartFile image;

  const UploadImageParams({required this.image});

  @override
  List<Object?> get props => [image];
}

final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  final datasource = ref.read(laptopRemoteDatasourceProvider);
  return UploadImageUsecase(datasource: datasource);
});

class UploadImageUsecase
    implements UsecaseWithParams<String, UploadImageParams> {
  final ILaptopRemoteDataSource _datasource;

  UploadImageUsecase({required ILaptopRemoteDataSource datasource})
      : _datasource = datasource;

  @override
  Future<Either<Failure, String>> call(UploadImageParams params) async {
    try {
      final url = await _datasource.uploadImage(params.image);
      return Right(url);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to upload image',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
