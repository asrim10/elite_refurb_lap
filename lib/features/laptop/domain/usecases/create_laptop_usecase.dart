import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class CreateLaptopParams extends Equatable {
  final LaptopEntity laptop;

  const CreateLaptopParams({required this.laptop});

  @override
  List<Object?> get props => [laptop];
}

final createLaptopUsecaseProvider = Provider<CreateLaptopUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return CreateLaptopUsecase(laptopRepository: laptopRepository);
});

class CreateLaptopUsecase
    implements UsecaseWithParams<LaptopEntity, CreateLaptopParams> {
  final ILaptopRepository _laptopRepository;

  CreateLaptopUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, LaptopEntity>> call(CreateLaptopParams params) {
    return _laptopRepository.create(params.laptop);
  }
}
