import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/entities/laptop_entity.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class UpdateLaptopParams extends Equatable {
  final String id;
  final Map<String, dynamic> data;

  const UpdateLaptopParams({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

final updateLaptopUsecaseProvider = Provider<UpdateLaptopUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return UpdateLaptopUsecase(laptopRepository: laptopRepository);
});

class UpdateLaptopUsecase
    implements UsecaseWithParams<LaptopEntity, UpdateLaptopParams> {
  final ILaptopRepository _laptopRepository;

  UpdateLaptopUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, LaptopEntity>> call(UpdateLaptopParams params) {
    return _laptopRepository.update(params.id, params.data);
  }
}
