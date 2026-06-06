import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/laptop/data/repositories/laptop_repository.dart';
import 'package:EliteReurbLap/features/laptop/domain/repositories/laptop_repository.dart';

class DeleteLaptopParams extends Equatable {
  final String id;

  const DeleteLaptopParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteLaptopUsecaseProvider = Provider<DeleteLaptopUsecase>((ref) {
  final laptopRepository = ref.read(laptopRepositoryProvider);
  return DeleteLaptopUsecase(laptopRepository: laptopRepository);
});

class DeleteLaptopUsecase implements UsecaseWithParams<void, DeleteLaptopParams> {
  final ILaptopRepository _laptopRepository;

  DeleteLaptopUsecase({required ILaptopRepository laptopRepository})
      : _laptopRepository = laptopRepository;

  @override
  Future<Either<Failure, void>> call(DeleteLaptopParams params) {
    return _laptopRepository.delete(params.id);
  }
}
