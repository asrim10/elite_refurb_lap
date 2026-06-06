import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class GetAllLaptopsParams extends Equatable {
  final Map<String, dynamic>? queryParameters;

  const GetAllLaptopsParams({this.queryParameters});

  @override
  List<Object?> get props => [queryParameters];
}

final getAllLaptopsUsecaseProvider = Provider<GetAllLaptopsUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return GetAllLaptopsUsecase(laptopRepository: laptopRepository);
});

class GetAllLaptopsUsecase
    implements UsecaseWithParams<List<LaptopEntity>, GetAllLaptopsParams> {
  final ILaptopRepository _laptopRepository;

  GetAllLaptopsUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, List<LaptopEntity>>> call(
      GetAllLaptopsParams params) {
    return _laptopRepository.getAll(queryParameters: params.queryParameters);
  }
}
