import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class GetLaptopByIdParams extends Equatable {
  final String id;

  const GetLaptopByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getLaptopByIdUsecaseProvider = Provider<GetLaptopByIdUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return GetLaptopByIdUsecase(laptopRepository: laptopRepository);
});

class GetLaptopByIdUsecase
    implements UsecaseWithParams<LaptopEntity, GetLaptopByIdParams> {
  final ILaptopRepository _laptopRepository;

  GetLaptopByIdUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, LaptopEntity>> call(GetLaptopByIdParams params) {
    return _laptopRepository.getById(params.id);
  }
}
